# frozen_string_literal: true
class Project < ApplicationRecord
  validates_with ProjectValidator
  has_many :provenance_events, dependent: :destroy

  # Valid project status described in ADR 7
  # See `architecture-decisions/0007-valid-project-statuses.md`
  PENDING_STATUS = "pending"
  APPROVED_STATUS = "approved"
  ACTIVE_STATUS = "active"
  
  delegate :to_json, to: :metadata_json

  def metadata
    (metadata_json || {}).with_indifferent_access
  end

  def metadata_model(current_user:)
    ProjectMetadata.new(current_user:, project: self)
  end

  def metadata=(metadata)
    self.metadata_json = metadata
  end

  # TODO: Presumably we should display other statuses as well?
  def title
    trailer = if in_mediaflux?
                ""
              else
                " (#{::Project::PENDING_STATUS})"
              end
    metadata[:title] + trailer
  end

  def departments
    unsorted = metadata[:departments] || []
    unsorted.sort
  end

  def directory
    metadata[:directory]
  end

  def status
    metadata[:status]
  end

  def in_mediaflux?
    mediaflux_id.present?
  end

  def self.sponsored_projects(sponsor)
    Project.where("metadata_json->>'data_sponsor' = ?", sponsor)
  end

  def self.managed_projects(manager)
    Project.where("metadata_json->>'data_manager' = ?", manager)
  end

  def self.pending_projects
    Project.where("mediaflux_id IS NULL")
  end

  def self.approved_projects
    Project.where("mediaflux_id IS NOT NULL")
  end

  def self.data_user_projects(user)
    # See https://scalegrid.io/blog/using-jsonb-in-postgresql-how-to-effectively-store-index-json-data-in-postgresql/
    # for information on the @> operator
    query_ro = '{"data_user_read_only":["' + user + '"]}'
    query_rw = '{"data_user_read_write":["' + user + '"]}'
    Project.where("(metadata_json @> ? :: jsonb) OR (metadata_json @> ? :: jsonb)", query_ro, query_rw)
  end

  def save_in_mediaflux(session_id:)
    if mediaflux_id.nil?
      self.mediaflux_id = ProjectMediaflux.create!(project: self, session_id: session_id)
      save!
      Rails.logger.debug "Project #{id} has been created in MediaFlux (asset id #{mediaflux_id})"
    else
      ProjectMediaflux.update(project: self, session_id: session_id)
      Rails.logger.debug "Project #{id} has been updated in MediaFlux (asset id #{mediaflux_id})"
    end
    mediaflux_id
  end

  def created_by_user
    User.find_by(uid: metadata[:created_by])
  end

  def to_xml
    ProjectMediaflux.xml_payload(project: self)
  end

  def mediaflux_document
    ProjectMediaflux.document(project: self)
  end

  def mediaflux_metadata(session_id:)
    @mediaflux_metadata ||= begin 
      accum_req = Mediaflux::Http::GetMetadataRequest.new(session_token: session_id, id: mediaflux_id)
      accum_req.metadata
    end
    @mediaflux_metadata
  end

  def asset_count(session_id:)
    values = mediaflux_metadata(session_id:)
    values.fetch(:total_file_count, 0)
  end

  def self.default_storage_usage
    "0 KB"
  end

  def storage_usage(session_id:)
    return unless in_mediaflux?

    values = mediaflux_metadata(session_id:)
    value = values.fetch(:size, 0)
    
    if value.blank?
      return self.class.default_storage_usage
    else
      return value
    end
  end

  def self.default_storage_capacity
    "0 GB"
  end

  def storage_capacity_xml

    mediaflux_document.at_xpath("/request/service/args/meta/tigerdata:project/StorageCapacity/text()", tigerdata: "http://tigerdata.princeton.edu")
  end

  def storage_capacity(session_id:)
    requested_capacity = storage_capacity_xml

    values = mediaflux_metadata(session_id:)
    quota_value = values.fetch(:quota_allocation, '') #if quota does not exist, set value to an empty string

    backup_value = requested_capacity || self.class.default_storage_capacity #return the default storage capacity, if the requested capacity is nil
    
    return backup_value if quota_value.blank?
    quota_value #return the requested storage capacity if a quota has not been set for a project, if storage has not been requested return "0 GB"
  end

  # Fetches the first n files
  def file_list(session_id:, size: 10)
    return { files: [] } if mediaflux_id.nil?

    query_req = Mediaflux::Http::QueryRequest.new(session_token: session_id, collection: mediaflux_id, deep_search: true)
    iterator_id = query_req.result

    iterator_req = Mediaflux::Http::IteratorRequest.new(session_token: session_id, iterator: iterator_id, size: size)
    results = iterator_req.result

    # Destroy _after_ fetching the first set of results from iterator_req.
    # This call is required since it possible that we have read less assets than
    # what the collection has but we are done with the iterator.
    Mediaflux::Http::IteratorDestroyRequest.new(session_token: session_id, iterator: iterator_id).resolve

    results
  end

  # Fetches the entire file list to a file
  def file_list_to_file(session_id:, filename:)
    return { files: [] } if mediaflux_id.nil?

    query_req = Mediaflux::Http::QueryRequest.new(session_token: session_id, collection: mediaflux_id, deep_search: true)
    iterator_id = query_req.result

    File.open(filename, "w") do |file|
      # file header
      file.write("ID, PATH, NAME, COLLECTION?, LAST_MODIFIED, SIZE\r\n")
      loop do
        iterator_req = Mediaflux::Http::IteratorRequest.new(session_token: session_id, iterator: iterator_id, size: 1000)
        iterator_resp = iterator_req.result
        lines = files_from_iterator(iterator_resp)
        file.write(lines.join("\r\n") + "\r\n")
        break if iterator_resp[:complete]
      end
    end

    # Destroy _after_ fetching the results from iterator_req
    # This call is technically not necessary since Mediaflux automatically deletes the iterator
    # once we have ran through it and by now we have. But it does not hurt either.
    Mediaflux::Http::IteratorDestroyRequest.new(session_token: session_id, iterator: iterator_id).resolve
  end

  private

    def files_from_iterator(iterator_resp)
      lines = []
      iterator_resp[:files].each do |asset|
        lines << "#{asset.id}, #{asset.path_only}, #{asset.name}, #{asset.collection}, #{asset.last_modified}, #{asset.size}"
      end
      lines
    end
end
