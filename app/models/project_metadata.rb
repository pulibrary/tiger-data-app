# frozen_string_literal: true
class ProjectMetadata
  attr_reader :project, :current_user, :params
  def initialize(current_user:, project:)
    @project = project
    @current_user = current_user
  end

  def update_metadata(params:)
    @params = params
    form_metadata
  end

  def create( params:)
    project.metadata = update_metadata(params:)
    if project.valid? && project.metadata["project_id"].blank?
      puldatacite = PULDatacite.new
      project.metadata_json["project_id"] = puldatacite.draft_doi
      project.save!
    end
    project.metadata["project_id"]
  end

    private

      def read_only_counter
        params[:ro_user_counter].to_i
      end

      def read_write_counter
        params[:rw_user_counter].to_i
      end

      def user_list_params(counter, key_prefix)
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
          timestamps[:created_on] = DateTime.now.strftime("%d-%b-%Y %H:%M:%S")

        else
          timestamps[:created_by] = project.metadata[:created_by]
          timestamps[:created_on] = project.metadata[:created_on]
          timestamps[:updated_by] = current_user.uid
          timestamps[:updated_on] = DateTime.now.strftime("%d-%b-%Y %H:%M:%S")
        end
        timestamps
      end

      def form_metadata
        ro_users = user_list_params(read_only_counter, "ro_user_")
        rw_users = user_list_params(read_write_counter, "rw_user_")
        data = {
          data_sponsor: params[:data_sponsor],
          data_manager: params[:data_manager],
          departments: params[:departments],
          directory: params[:directory],
          title: params[:title],
          description: params[:description],
          status: params[:status],
          data_user_read_only: ro_users,
          data_user_read_write: rw_users,
          project_id: project.metadata[:project_id],
          storage_capacity: project.metadata[:storage_capacity],
          storage_performance: project.metadata[:storage_performance],
          project_purpose: project.metadata[:project_purpose]    
        }
        timestamps = project_timestamps
        data.merge(timestamps)
      end
end
