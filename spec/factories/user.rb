# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: "User" do
    uid { FFaker::InternetSE.unique.login_user_name }
    display_name { FFaker::Name.name }
    given_name { display_name.split(" ").first }
    family_name { display_name.split(" ").last }
    provider { :cas }
    email { "#{uid}@example.com" }
    eligible_sponsor { false }
    eligible_manager { false }
    sysadmin { false }
    superuser { false }
    tester_trainer { false }

    ##
    # A user who is allowed to sponsor a project
    factory :project_sponsor do
      eligible_sponsor { true }
    end

    ##
    # A user who is allowed to manage a project
    factory :data_manager do
      eligible_manager { true }
    end

    ##
    # A user who is a tester trainer for TigerData
    factory :tester_trainer do
      tester_trainer { true }
    end

    ##
    # A user who is both a Data Sponsor and a Data Manager
    factory :project_sponsor_and_data_manager do
      eligible_sponsor { true }
      eligible_manager { true }
    end

    ##
    # A user who is allowed to approve a project
    factory :sysadmin do
      sysadmin { true }
    end

    ##
    # A user who is allowed see all projects in the system
    factory :superuser do
      superuser { true }
    end
  end
end
