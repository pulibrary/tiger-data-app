# frozen_string_literal: true

class UserJob < ApplicationRecord
  def title
    "File Inventory for \"#{project_title}\""
  end

  def created_datestamp
    localized = created_at.localtime
    localized.strftime("%Y-%m-%dT%H:%M:%S%:z")
  end

  def updated_datestamp
    localized = updated_at.localtime
    localized.strftime("%Y-%m-%dT%H:%M:%S%:z")
  end

  def description
    if complete
      "Completed #{updated_datestamp}"
    else
      "Requested #{created_datestamp}"
    end
  end

  def self.create_and_link_to_user(job_id:, user:, job_title:)
    user_job = UserJob.where(job_id: job_id).first
    if user_job.nil?
      user_job = UserJob.create(job_id: job_id, project_title: job_title)
      user.user_jobs << user_job
      user.save!
    end
    user_job
  end
end
