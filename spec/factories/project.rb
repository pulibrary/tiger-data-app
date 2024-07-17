# frozen_string_literal: true

FactoryBot.define do
  factory :project, class: "Project" do
    transient do
      data_sponsor { FactoryBot.create(:project_sponsor).uid }
      data_manager { FactoryBot.create(:data_manager).uid }
      data_user_read_only { [] }
      data_user_read_write { [] }
      title { FFaker::Movie.title }
      created_on { Time.current.in_time_zone("America/New_York").iso8601 }
      created_by { FactoryBot.create(:user).uid }
      updated_on { Time.current.in_time_zone("America/New_York").iso8601 }
      updated_by { FactoryBot.create(:user).uid }
      project_id { "" }
      status { "pending" }
      storage_capacity { { size: { requested: 500 }, unit: { requested: "GB" } }.with_indifferent_access }
      storage_performance { { requested: "standard" }.with_indifferent_access }
      project_purpose { "research" }
      project_directory { "big-data" }
      schema_version { ::TigerdataSchema::SCHEMA_VERSION }
      approved_by { nil }
      approved_on { nil }
      # TODO: remove submission from the project factory
      submission do
        {
          requested_by: FactoryBot.create(:user).uid,
          request_date_time: Time.current.in_time_zone("America/New_York").iso8601
        }
      end
    end
    metadata_model do
      hash = {
        data_sponsor: data_sponsor,
        data_manager: data_manager,
        data_user_read_only: data_user_read_only,
        data_user_read_write: data_user_read_write,
        departments: ["RDSS", "PRDS"],
        project_directory: project_directory,
        title: title,
        description: "a random description",
        created_on: created_on,
        created_by: created_by,
        updated_on: updated_on,
        updated_by: updated_by,
        project_id: project_id,
        status: status,
        storage_capacity: storage_capacity,
        storage_performance_expectations: storage_performance,
        project_purpose: project_purpose,
        schema_version: schema_version,
        approved_by: approved_by,
        approved_on: approved_on,
        submission: submission
      }
      ProjectMetadata.new_from_hash(hash)
    end
    mediaflux_id { nil }

    factory :project_with_doi, class: "Project" do
      sequence :project_id do |n|
        "doi:000000#{n}/00000000000#{n}"
      end
    end

    factory :project_with_dynamic_directory, class: "Project" do
      transient do
        sequence :project_directory do |n|
          Project.safe_name("#{FFaker::Food.fruit}#{n}")
        end
      end
    end

    factory :approved_project, class: "Project" do
      transient do
        storage_capacity { { size: { requested: 500, approved: 600 }, unit: { requested: "GB", approved: "KB" } }.with_indifferent_access }
        storage_performance { { requested: "standard", approved: "performant" }.with_indifferent_access }
        status { "approved" }
        approved_by { FactoryBot.create(:sysadmin).uid }
        approved_on { Time.current.in_time_zone("America/New_York").iso8601 }
        project_id { "10.34770/tbd" }
      end
    end
  end
end
