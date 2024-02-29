# frozen_string_literal: true
class ProjectsController < ApplicationController
  def new
    if current_user.eligible_sponsor?
    new_project
    else redirect_to root_path
    end
  end

  def project_params
    values = params.dup
  end

  def create
    new_project
    project_metadata = ProjectMetadata.new( current_user:, project: new_project)
    new_project_params = params.dup
    metadata_params = new_project_params.merge({
      status: Project::PENDING_STATUS
    })
    project_metadata.create(params: metadata_params)
    if new_project.save
      mailer = TigerdataMailer.with(project_id: @project.id)
      message_delivery = mailer.project_creation
      message_delivery.deliver_later

      redirect_to project_confirmation_path(@project)
    else
      render :new
    end
  rescue RedisClient::CannotConnectError => redis_connect_error
    error_message = "We are sorry, while the project was successfully created, an error was encountered which prevents the delivery of an e-mail message confirming this. Please know that this error has been logged, and shall be reviewed by members of RDSS."

    Rails.logger.error(error_message)
    Honeybadger.notify(redis_connect_error, context: { current_user_email: current_user.email, project_id: @project.id })

    flash[:notice] = error_message
    render :new
  end

  def show
    project
    @departments = project.departments.join(", ")
    @project_metadata = project.metadata

    sponsor_uid = @project_metadata[:data_sponsor]
    @data_sponsor = User.find_by(uid: sponsor_uid)

    manager_uid = @project_metadata[:data_manager]
    @data_manager = User.find_by(uid: manager_uid)

    read_only_uids = @project_metadata.fetch(:data_user_read_only, [])
    data_read_only_users = read_only_uids.map { |uid| ReadOnlyUser.find_by(uid:) }.reject(&:blank?)

    read_write_uids = @project_metadata.fetch(:data_user_read_write, [])
    data_read_write_users = read_write_uids.map { |uid| User.find_by(uid:) }.reject(&:blank?)

    unsorted_data_users = data_read_only_users + data_read_write_users
    sorted_data_users = unsorted_data_users.sort_by { |u| u.family_name || u.uid }
    @data_users = sorted_data_users.uniq { |u| u.uid }
    user_model_names = @data_users.map(&:display_name_safe)
    @data_user_names = user_model_names.join(", ")

    @submission_events = project.provenance_events.where(event_type: ProvenanceEvent::SUBMISSION_EVENT_TYPE)
    @project_status = project.metadata[:status]

    @approve_status = Project::APPROVE_STATUS
    @eligible_editor = eligible_editor?
    @project_eligible_to_edit = true if @project_status == @approve_status && eligible_editor?

    respond_to do |format|
      format.html
      format.json do
        render json: project.to_json
      end
      format.xml do
        render xml: project.to_xml
      end
    end
  end

  def edit
    project
    if project.metadata[:status] != Project::APPROVE_STATUS
      flash[:notice] = "Pending projects can not be edited."
      redirect_to project
    elsif project.metadata[:status] == Project::APPROVE_STATUS && !eligible_editor? #check if the current user is a sponsor of manager
      flash[:notice] = "Only data sponsors and data managers can revise this project."
      redirect_to project
    end
  end

  def update
    project
    #Approve action
    if params.key?("mediaflux_id")
      project.mediaflux_id = params["mediaflux_id"]
      project.metadata_json["status"] = Project::APPROVE_STATUS
      params.delete("mediaflux_id")
    end

    #Edit action
    if params.key?("title")
      project_metadata = ProjectMetadata.new(project: project, current_user:)
      project_params = params.dup
      metadata_params = project_params.merge({
        status: project.metadata[:status]
      })
      project.metadata = project_metadata.update_metadata(params: metadata_params)
    end

    # @todo ProjectMetadata should be refactored to implement ProjectMetadata.valid?(updated_metadata)
    if project.save
      redirect_to project_revision_confirmation_path(@project)
    else
      render :edit
    end
  end

  def index
    @projects = Project.all
  end

  def confirmation; end
  def revision_confirmation; end

  def contents
    project
    @num_files = project.asset_count(session_id: current_user.mediaflux_session)
    @file_list = project.file_list(session_id: current_user.mediaflux_session, size: 100)
    @file_list[:files].sort_by!(&:path)
  end

  def project_job_service
    @project_job_service ||= ProjectJobService.new(project:)
  end

  def list_contents
    project_job_service.list_contents_job(user: current_user)

    json_response = {
      message: "File list for \"#{project.title}\" is being generated in the background."
    }
    render json: json_response
  rescue => ex
    message = "Error producing document list (project id: #{project&.id}): #{ex.message}"
    Rails.logger.error(message)
    Honeybadger.notify(message)
    render json: { message: "Document list could not be generated." }
  end

  def file_list_download
    job_id = params[:job_id]
    user_job = UserJob.where(job_id:job_id).first
    if user_job.nil?
      # TODO: handle error
      redirect_to "/"
    else
      filename = "#{Dir.pwd}/public/#{job_id}.csv"
      send_data File.read(filename), type: "text/plain", filename: "filelist.csv", disposition: "attachment"
    end
  end

  def approve
    if current_user.eligible_sysadmin?
      project
      @project_metadata = project.metadata
      @title = @project_metadata["title"]
    else redirect_to root_path
    end
  end

  private

    def new_project
      @project ||= Project.new
    end

    def project
      @project ||= Project.find(params[:id])
    end

    def eligible_editor?
      return true if current_user.eligible_sponsor? or current_user.eligible_manager?
    end
end
