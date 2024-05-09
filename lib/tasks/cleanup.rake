# frozen_string_literal: true
namespace :mediaflux do
  desc "Delete everything from the current environment (use with caution)"
  task destructive_cleanup: :environment do
    raise "You can't run this in production!" if Rails.env.production?
    login = Mediaflux::Http::LogonRequest.new
    login.resolve
    session_id = login.session_token
    message = "Deleting everything from mediaflux namespace: #{Rails.configuration.mediaflux[:api_root_ns]}"
    puts message
    Rails.logger.warn message
    Mediaflux::Http::NamespaceDestroyRequest.new(session_token: session_id, namespace: Rails.configuration.mediaflux[:api_root_ns]).destroy
    [UserJob, User, Project].each(&:delete_all)
    # Now load the users for this environment from the registration list
    Rake::Task["load_users:from_registration_list"].execute
  end
end