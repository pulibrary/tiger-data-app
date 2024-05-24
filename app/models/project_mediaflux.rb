# frozen_string_literal: true

# A custom exception class for when a namespace path is already taken
class MediafluxDuplicateNamespaceError < StandardError
end

# Take an instance of Project and adds it to MediaFlux
class ProjectMediaflux

  attr_reader :project, :session_id, :xml_namespace, :store_name, :project_name, :project_parent

  def initialize(project:, session_id:, xml_namespace: nil)
    @project = project
    @session_id = session_id
    @xml_namespace = xml_namespace
    @store_name = Store.default(session_id: session_id).name
    @project_name = project.project_directory
    @project_parent = Rails.configuration.mediaflux["api_root_collection"]
    # Create a collection asset under the root namespace and set its metadata
    prepare_parent_collection
  end

  # Create a project in MediaFlux
  #
  # @param project [Project] the project that needs to be added to MediaFlux
  # @param session_id [] the session id for the user who is currently authenticated to MediaFlux
  # @param xml_namespace [] 
  # @return [String] The id of the project that got created
  def self.create!(project:, session_id:, xml_namespace: nil)
    pm = ProjectMediaflux.new(project: project, session_id: session_id, xml_namespace: xml_namespace)

    # Make sure the root namespace exists
    pm.create_root_ns

    # Create a namespace for the project
    pm.create_project_ns

    # Create the project asset in MediaFlux
    id = pm.create_project_asset

    self.create_accumulators(mediaflux_project_id: id, session_id: session_id)
    self.create_quota(project: project, mediaflux_project_id: id, session_id: session_id)
    id
  end

  # Create a project asset in MediaFlux
  def create_project_asset
    create_request = Mediaflux::Http::AssetCreateRequest.new(
                      session_token: @session_id, 
                      namespace: @project_namespace, 
                      name: @project.project_directory_short, 
                      tigerdata_values: @project_values,
                      xml_namespace: @xml_namespace, 
                      pid: @project_parent
                      )
    id = create_request.id
    if id.blank?
      response_error = create_request.response_error
      byebug
      case response_error[:message]
      when "failed: The namespace #{@project_namespace} already contains an asset named '#{@project_name}'"
        raise "Project name already taken"
      when /'asset.create' failed/
        # Ensure that the metadata validations are run
        if @project.valid?
          raise response_error[:message]  # something strange went wrong
        else
          raise TigerData::MissingMetadata.missing_metadata(
                  schema_version: ::TigerdataSchema::SCHEMA_VERSION, 
                  errors: project.errors
                  )
        end
      else
        raise(StandardError,"An error has occured during project creation, not related to namespace creation or collection creation")
      end
    end
    @project.mediaflux_id = id
    @project.save!
    id
  end

  def project_namespace 
    "#{@project_name}NS"
  end

  # Create a namespace for the project
  def create_project_ns
    namespace = Mediaflux::Http::NamespaceCreateRequest.new(
                  namespace: project_namespace, 
                  description: "Namespace for project #{@project.title}", 
                  store: @store_name, 
                  session_token: @session_id
                  )
    if namespace.error?
      raise MediafluxDuplicateNamespaceError.new("Can not create the namespace #{namespace.response_error}")
    end
  end

  # Create accumulators for all newly created mediaflux projects
  #
  # @param mediaflux_project_id [] the id of the project that needs accumulators
  # @param session_id [] the session id for the user who is currently authenticated to MediaFlux
  def self.create_accumulators(mediaflux_project_id:, session_id:)
    accum_count = Mediaflux::Http::CreateCollectionAccumulatorRequest.new(
      session_token: session_id, 
      name: "accum-count", 
      collection: mediaflux_project_id, 
      type: "collection.asset.count"
      )
    accum_count.resolve
    accum_size = Mediaflux::Http::CreateCollectionAccumulatorRequest.new(
      session_token: session_id, 
      name: "accum-size", 
      collection: mediaflux_project_id, 
      type: "content.all.size"
      )
    accum_size.resolve
  end

  def self.create_quota(project:, mediaflux_project_id:, session_id:)
    #TODO: SHOULD WE CREATE A PROJECT USING REQUESTED VALUES OR APPROVED VALUES?
    allocation = project.metadata_json["storage_capacity"]["size"]["requested"].to_s << " " << project.metadata_json["storage_capacity"]["unit"]["requested"]
    quota_request = Mediaflux::Http::CreateCollectionQuotaRequest.new(
      session_token: session_id,
      collection: mediaflux_project_id,
      allocation: allocation
    )
    quota_request.resolve
  end

  def self.update(project:, session_id:)
    tigerdata_values = project_values(project: project)
    Mediaflux::Http::AssetUpdateRequest.new(session_token: session_id, id: project.mediaflux_id, tigerdata_values: tigerdata_values).resolve
  end

  # Translates database record into mediaflux meta document.
  # This is where the data for XML payload is generated.
  def project_values
    split_capacity  = @project.metadata[:storage_capacity_requested]&.split(" ") || []
    values = {
      project_directory: @project.project_directory,
      title: @project.metadata[:title],
      description: @project.metadata[:description],
      status: @project.metadata[:status],
      data_sponsor: @project.metadata[:data_sponsor],
      data_manager: @project.metadata[:data_manager],
      data_user_read_only: @project.metadata[:data_user_read_only],
      data_user_read_write: @project.metadata[:data_user_read_write],
      departments: @project.metadata[:departments],
      created_on: MediafluxTime.format_date_for_mediaflux(@project.metadata[:created_on]),
      created_by: @project.metadata[:created_by],
      updated_on: MediafluxTime.format_date_for_mediaflux(@project.metadata[:updated_on]),
      updated_by: @project.metadata[:updated_by],
      project_id: @project.metadata[:project_id],
      storage_capacity: @project.metadata[:storage_capacity].symbolize_keys,
      storage_performance: @project.metadata[:storage_performance_expectations].symbolize_keys,
      project_purpose: @project.metadata[:project_purpose]
    }
    values.with_indifferent_access
  end

  def self.project_values(project:)
    split_capacity  = project.metadata[:storage_capacity_requested]&.split(" ") || []
    values = {
      project_directory: project.project_directory,
      title: project.metadata[:title],
      description: project.metadata[:description],
      status: project.metadata[:status],
      data_sponsor: project.metadata[:data_sponsor],
      data_manager: project.metadata[:data_manager],
      data_user_read_only: project.metadata[:data_user_read_only],
      data_user_read_write: project.metadata[:data_user_read_write],
      departments: project.metadata[:departments],
      created_on: MediafluxTime.format_date_for_mediaflux(project.metadata[:created_on]),
      created_by: project.metadata[:created_by],
      updated_on: MediafluxTime.format_date_for_mediaflux(project.metadata[:updated_on]),
      updated_by: project.metadata[:updated_by],
      project_id: project.metadata[:project_id],
      storage_capacity: project.metadata[:storage_capacity].symbolize_keys,
      storage_performance: project.metadata[:storage_performance_expectations].symbolize_keys,
      project_purpose: project.metadata[:project_purpose]
    }
    values.with_indifferent_access
  end

  def self.xml_payload(project:, xml_namespace: nil)
    project_name = project.project_directory
    project_namespace = "#{project_name}NS"
    project_parent = Rails.configuration.mediaflux["api_root_collection"]

    tigerdata_values = project_values(project: project)
    create_request = Mediaflux::Http::AssetCreateRequest.new(session_token: nil, namespace: project_namespace, name: project.project_directory_short, tigerdata_values: tigerdata_values,
                                                             xml_namespace: xml_namespace, pid: project_parent)
    create_request.xml_payload
  end

  def self.document(project:, xml_namespace: nil)
    xml_body = xml_payload(project:, xml_namespace:)
    Nokogiri::XML.parse(xml_body)
  end

  # Create the root namespace if it does not exist
  def create_root_ns
    root_namespace = Rails.configuration.mediaflux["api_root_ns"]
    namespace_request = Mediaflux::Http::NamespaceDescribeRequest.new(
                          path: root_namespace, 
                          session_token: @session_id
                          )
    if namespace_request.exists?
      Rails.logger.debug "Root namespace #{root_namespace} already exists"
    else
      Rails.logger.info "Created root namespace #{root_namespace}"
      namespace_request = Mediaflux::Http::NamespaceCreateRequest.new(
                            namespace: root_namespace, 
                            description: "TigerData client app root namespace",
                            store: Store.all(session_id: @session_id).first.name,
                            session_token: @session_id)
      namespace_request.response_body
    end
  end

  private
    def prepare_parent_collection
      get_parent = Mediaflux::Http::AssetMetadataRequest.new(
                    session_token: @session_id, 
                    id: @project_parent
                    )
      if get_parent.error?
        if project_parent.include?("path=")
          create_parent_request = Mediaflux::Http::AssetCreateRequest.new(
                                    session_token: @session_id, 
                                    namespace: Rails.configuration.mediaflux["api_root_collection_namespace"],
                                    name: Rails.configuration.mediaflux["api_root_collection_name"]
                                    )
          raise "Can not create parent collection: #{create_parent_request.response_error}" if create_parent_request.error?
        end
      end    
    end
end
