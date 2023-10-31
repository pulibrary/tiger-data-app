# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Project Page", type: :system, stub_mediaflux: true do
  let(:sponsor_user) { FactoryBot.create(:user, uid: "pul123") }
  let(:read_only) { FactoryBot.create :user }
  let(:read_write) { FactoryBot.create :user }
  let(:metadata) do
    {
      data_sponsor: "pul123",
      data_manager: "pul987",
      directory: "project-123",
      title: "project 123",
      departments: ["RDSS"],
      description: "hello world",
      data_user_read_only: [read_only.uid],
      data_user_read_write: [read_write.uid]
    }
  end

  let(:project_not_in_mediaflux) { FactoryBot.create(:project, metadata: metadata) }

  let(:project_in_mediaflux) do
    project = FactoryBot.create(:project, metadata: metadata)
    project.approve!(session_id: sponsor_user.mediaflux_session, created_by: sponsor_user.uid)
    project
  end

  before do
    stub_request(:post, "http://mediaflux.example.com:8888/__mflux_svc__")
      .with(
        body: /<service name="asset.namespace.create" session="test-session-token">/
      ).to_return(status: 200, body: "<xml>something</xml>")

    stub_request(:post, "http://mediaflux.example.com:8888/__mflux_svc__")
      .with(
        body: /<service name="asset.create" session="test-session-token">/
      ).to_return(status: 200, body: "<?xml version=\"1.0\" ?> <response> <reply type=\"result\"> <result> <id>999</id> </result> </reply> </response>")

    stub_request(:post, "http://mediaflux.example.com:8888/__mflux_svc__")
      .with(
        body: /<service name="asset.set" session="test-session-token">/
      ).to_return(status: 200, body: "<?xml version=\"1.0\" ?> <response> <reply type=\"result\"> <result> <id>999</id> </result> </reply> </response>")

    sign_in sponsor_user
  end

  context "Show page" do
    it "shows the project data" do
      sign_in sponsor_user
      visit "/projects/#{project_not_in_mediaflux.id}"
      expect(page).to have_content "project 123"
      expect(page).to have_content "This project has not been saved to Mediaflux"
      expect(page).not_to have_button "Approve Project"
    end

    context "An Mediaflux Administrator" do
      let(:mediaflux_admin_user) { FactoryBot.create(:mediaflux_admin) }

      it "shows the project data and the Approve Project button" do
        sign_in mediaflux_admin_user
        visit "/projects/#{project_not_in_mediaflux.id}"
        expect(page).to have_content "project 123"
        expect(page).to have_content "This project has not been saved to Mediaflux"
        expect(page).to have_button "Approve Project"
      end
    end

    it "shows the Mediaflux id for a project saved in Mediaflux" do
      sign_in sponsor_user
      visit "/projects/#{project_in_mediaflux.id}"
      expect(page).to have_content "project 123"
      expect(page).to have_content "Mediaflux id: 999"
      expect(page).not_to have_button "Approve Project"
    end
  end

  context "Edit page" do
    it "preserves the readonly directory field" do
      sign_in sponsor_user
      visit "/projects/#{project_in_mediaflux.id}/edit"
      click_on "Save"
      project_in_mediaflux.reload
      expect(project_in_mediaflux.metadata[:directory]).to eq "project-123"
    end
  end

  context "Create page" do
    let(:data_manager) { FactoryBot.create :user }
    it "allows the user to create a project" do
      sign_in sponsor_user
      visit "/"
      click_on "New Project"
      fill_in "data_sponsor", with: sponsor_user.uid
      fill_in "data_manager", with: data_manager.uid
      fill_in "data_user_read_only", with: read_only.uid
      fill_in "data_user_read_write", with: read_write.uid
      fill_in "directory", with: "test_project"
      fill_in "title", with: "My test project"
      expect(page).to have_content("Project Directory: /td-test-001/")
      expect do
        click_on "Save"
      end.to have_enqueued_job(ActionMailer::MailDeliveryJob).exactly(1).times
      expect(page).to have_content("This project has not been saved to Mediaflux")
      expect(page).to have_content("My test project")
      expect(page).to have_content(read_only.uid)
      expect(page).to have_content(read_write.uid)
    end
  end
end
