# frozen_string_literal: true
class ListProjectContentsJob < ApplicationJob
  def perform(user_id:, project_id:)
    project = Project.find(project_id)
    raise "Invalid project id #{project_id} for job #{job_id}" if project.nil?
    user = User.find(user_id)
    raise "Invalid user id #{user_id} for job #{job_id}" if user.nil?

    # Queries Mediaflux for the file list and saves it to a CSV file.
    filename = filename_for_export
    Rails.logger.info "Exporting file list to #{filename} for project #{project_id}"
    project.file_list_to_file(session_id: mediaflux_session, filename: filename)
    Rails.logger.info "Export file generated #{filename} for project #{project_id}"

    mark_user_job_as_complete(project: project, user: user)
  end

  private

    def mediaflux_session
      logon_request = Mediaflux::Http::LogonRequest.new
      logon_request.resolve
      logon_request.session_token
    end

    def filename_for_export
      raise "Shared location is not configured" if Rails.configuration.mediaflux["shared_files_location"].blank?
      pathname = Pathname.new(Rails.configuration.mediaflux["shared_files_location"])
      pathname.join("#{job_id}.csv").to_s
    end

    def mark_user_job_as_complete(project:, user:)
      user_job = UserJob.create_and_link_to_user(job_id: job_id, user: user, job_title: "File list for #{project.title}")
      user_job.completed_at = Time.current.in_time_zone("America/New_York").iso8601
      user_job.save!
      user_job.reload
    end
end
