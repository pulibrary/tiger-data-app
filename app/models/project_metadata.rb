# frozen_string_literal: true
class ProjectMetadata
  attr_reader :project, :current_user, :params
  attr_accessor :title, :description, :status, :data_sponsor, :data_manager, :departments, :ro_users, :rw_users, :created_on, :created_by, :project_id, :project_purpose, :storage_capacity,
:storage_performance_expectations, :updated_by, :updated_on

  def initialize(project:, current_user: nil)
    @project = project
    initialize_from_metadata
    @current_user = current_user
    @params = {}
  end

  # https://gist.github.com/jrgriffiniii/d60e05fbbae0088c4abacf84805591e5
  # Hack to get the old access to properties to work.
  # Should be removed once the refactor has been completed.
  def [](key)
    value = self.send(key)
  end

  def []=(key, value)
    self.send(key, value)
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def initialize_from_metadata
    @title = project.metadata[:title]
    @description = project.metadata[:description]
    @status = project.metadata[:status]
    @data_sponsor = project.metadata[:data_sponsor]
    @data_manager = project.metadata[:data_manager]
    @departments = project.metadata[:departments]
    @ro_users = project.metadata[:data_user_read_only]
    @rw_users = project.metadata[:data_user_read_write]
    @created_on = project.metadata[:created_on]
    @created_by = project.metadata[:created_by]
    @project_id = project.metadata[:project_id]
    @project_purpose = project.metadata[:project_purpose]
    @storage_capacity = project.metadata[:storage_capacity]
    @storage_performance_expectations = project.metadata[:storage_performance_expectations]
    @updated_by = project.metadata[:updated_by]
    @updated_on = project.metadata[:updated_on]
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  # Generate a Hash of updated Project metadata attributes
  # @param params [Hash] the updated Project metadata attributes
  # @return [Hash]
  def update_metadata(params:)
    byebug
    @params = params
    form_metadata
  end

  def activate_project(collection_id:, current_user:)
    response = Mediaflux::Http::AssetMetadataRequest.new(session_token: current_user.mediaflux_session, id: collection_id)
    metadata = response.metadata
    return unless metadata[:collection] == true # If the collection id exists

    # check if the project doi in rails matches the project doi in mediaflux
    return unless metadata[:project_id] == project.metadata_json["project_id"]

    # activate a project by setting the status to 'active'
    project.metadata_json["status"] = Project::ACTIVE_STATUS

    # also read in the actual project directory
    project.metadata_json["project_directory"] = metadata[:project_directory]

    project.save!

    # create two provenance events, one for approving the project and another for changing the status of the project
    project.provenance_events.create(event_type: ProvenanceEvent::ACTIVE_EVENT_TYPE, event_person: current_user.uid, event_details: "Activated by Tigerdata Staff")
    project.provenance_events.create(event_type: ProvenanceEvent::STATUS_UPDATE_EVENT_TYPE, event_person: current_user.uid, event_details: "The Status of this project has been set to active")
  end

  # Approve a project by recording the mediaflux id & setting the status to 'approved'
  # @param params [Hash] the updated Project metadata attributes
  def approve_project(params:)
    project.mediaflux_id = params[:mediaflux_id]
    project.metadata_json["status"] = Project::APPROVED_STATUS
    project.metadata_json["project_directory"] = "#{params[:project_directory_prefix]}/#{params[:project_directory]}"
    project.metadata_json["storage_capacity"] = params[:storage_capacity]
    project.metadata_json["storage_performance_expectations"] = params[:storage_performance_expectations]

    project.save!
    generate_approval_events(params[:approval_note])
  end

  def generate_approval_events(note)
    # create two provenance events, one for approving the project and another for changing the status of the project
    project.provenance_events.create(event_type: ProvenanceEvent::APPROVAL_EVENT_TYPE, event_person: current_user.uid, event_details: "Approved by #{current_user.display_name_safe}",
                                     event_note: note)
    project.provenance_events.create(event_type: ProvenanceEvent::STATUS_UPDATE_EVENT_TYPE, event_person: current_user.uid, event_details: "The Status of this project has been set to approved")
  end

  def create(params:)
    byebug

    # Store the params into the class properties and pass the class to the project
    # project.metadata = update_metadata(params: params)
    initialize_from_params(params: params)
    project.metadata = self.to_json

    # WARNING: This gets into a circular reference between project and project metadata.
    if project.valid? && project.metadata["project_id"].blank?
      draft_doi
    end
    project.metadata["project_id"]
  end

  def attributes
    {
      data_sponsor: params[:data_sponsor],
      data_manager: params[:data_manager],
      departments: params[:departments],
      project_directory: params[:project_directory],
      title: params[:title],
      description: params[:description],
      status: params[:status] || project.metadata[:status],
      project_id: project.metadata[:project_id] || "", # allow validation to pass until doi can be generated
      storage_capacity: project.metadata[:storage_capacity],
      storage_performance_expectations: project.metadata[:storage_performance_expectations],
      project_purpose: project.metadata[:project_purpose]
    }
  end

    private

      def read_only_counter
        return if params.nil?
        params[:ro_user_counter].to_i
      end

      def read_write_counter
        return if params.nil?
        params[:rw_user_counter].to_i
      end

      def user_list_params(counter, key_prefix)
        return if params.nil?

        users = []
        (1..counter).each do |i|
          key = "#{key_prefix}#{i}"
          users << params[key]
        end
        users.compact.uniq
      end

      def project_timestamps
        timestamps = {}
        if project.metadata[:created_by].nil?
          timestamps[:created_by] = current_user.uid
          timestamps[:created_on] = Time.current.in_time_zone("America/New_York").iso8601

        else
          timestamps[:created_by] = project.metadata[:created_by]
          timestamps[:created_on] = project.metadata[:created_on]
          timestamps[:updated_by] = current_user.uid
          timestamps[:updated_on] = Time.current.in_time_zone("America/New_York").iso8601
        end
        timestamps
      end

      def form_metadata
        ro_users = user_list_params(read_only_counter, "ro_user_")
        rw_users = user_list_params(read_write_counter, "rw_user_")
        data_users = {
          data_user_read_only: ro_users,
          data_user_read_write: rw_users
        }
        data = attributes.merge(data_users)
        timestamps = project_timestamps
        data.merge(timestamps)
      end

      def initialize_from_params(params:)
        self.ro_users = user_list_params(read_only_counter, "ro_user_")
        self.rw_users = user_list_params(read_write_counter, "rw_user_")

        # TODO: figure out if we need to create accessor for data_users
        data_users = {
          data_user_read_only: ro_users,
          data_user_read_write: rw_users
        }

        self.data_sponsor = params[:data_sponsor]
        self.data_manager = params[:data_manager]
        self.departments = params[:departments]
        # self.project_directory = params[:project_directory]
        self.title = params[:title]
        self.description = params[:description]
        self.status = params[:status] # || project.metadata[:status]
        # self.project_id = project.metadata[:project_id] || "" # allow validation to pass until doi can be generated
        # self.storage_capacity = project.metadata[:storage_capacity]
        # self.storage_performance_expectations = project.metadata[:storage_performance_expectations]
        # self.project_purpose = project.metadata[:project_purpose]

        # TODO: figure out timestamps
        # data = attributes.merge(data_users)
        timestamps = project_timestamps
        # data.merge(timestamps)
      end

      def draft_doi
        puldatacite = PULDatacite.new
        project.metadata_json["project_id"] = puldatacite.draft_doi
        project.save!
        data_sponsor = User.find_by(uid: project.metadata[:data_sponsor])
        project.provenance_events.create(event_type: ProvenanceEvent::SUBMISSION_EVENT_TYPE, event_person: current_user.uid, event_details: "Requested by #{data_sponsor.display_name_safe}")
        project.provenance_events.create(event_type: ProvenanceEvent::STATUS_UPDATE_EVENT_TYPE, event_person: current_user.uid, event_details: "The Status of this project has been set to pending")
      end
end
