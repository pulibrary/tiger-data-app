# frozen_string_literal: true
require "rails_helper"

RSpec.describe ProjectMetadata, type: :model do
  let(:current_user) { FactoryBot.create(:user, uid: "hc1234") }
  let(:project) { Project.new }

  context "when no project is present" do
    describe "#update_metadata" do

      it "parses the basic metadata" do
        params = {data_sponsor: "abc", data_manager: "def", departments: "dep", directory: "dir", title: "title abc", description: "description 123", status: "pending" }
        project_metadata = described_class.new(current_user: current_user, project: project)
        update = project_metadata.update_metadata(params: params)
        expect(update[:data_sponsor]).to eq("abc")
        expect(update[:data_manager]).to eq("def")
        expect(update[:departments]).to eq("dep")
        expect(update[:directory]).to eq("dir")
        expect(update[:title]).to eq("title abc")
        expect(update[:description]).to eq("description 123")
        expect(update[:status]).to eq("pending")
      end

      it "returns metdata with create timestamps" do
        project_metadata = described_class.new(current_user: current_user, project: project)
        update = project_metadata.update_metadata(params: {})
        expect(update[:created_by]).to eq(current_user.uid)
        expect(update[:created_on]).to be_present
        expect(update[:updated_on]).not_to be_present
        expect(update[:updated_by]).not_to be_present
      end

      it "parses the read only users" do
        project_metadata = described_class.new(current_user: current_user, project: project)
        update = project_metadata.update_metadata(params: {"ro_user_1" => "abc", ro_user_counter: "1" })
        expect(update[:data_user_read_only]).to eq(["abc"])
      end

      it "parses empty read only users" do
        project_metadata = described_class.new(current_user: current_user, project: project)
        update = project_metadata.update_metadata(params: {ro_user_counter: "0" })
        expect(update[:data_user_read_only]).to eq([])
      end

      it "parses the read/write users" do
        project_metadata = described_class.new(current_user: current_user, project: project)
        update = project_metadata.update_metadata(params:{"rw_user_1" => "abc", rw_user_counter: "1" })
        expect(update[:data_user_read_write]).to eq(["abc"])
      end

      it "parses empty read/write users" do
        project_metadata = described_class.new(current_user: current_user, project: project)
        update = project_metadata.update_metadata(params: {rw_user_counter: "0" })
        expect(update[:data_user_read_write]).to eq([])
      end
    end

    describe "#create" do
      let(:datacite_stub) { instance_double(PULDatacite, draft_doi: "aaabbb123") }
      before do
        allow(PULDatacite).to receive(:new).and_return(datacite_stub)
      end

      it "does not call draft doi" do
        project_metadata = described_class.new(current_user: current_user, project: Project.new)
        update = project_metadata.create(params: {})
        expect(datacite_stub).not_to have_received(:draft_doi)
        expect(update).to be_nil
      end
    end
  end

  context "when a project is present" do
    let(:project) { FactoryBot.create :project }

    describe "#update_metadata" do

      it "returns metdata with create timestamps" do
        project_metadata = described_class.new(current_user: current_user, project:)
        update = project_metadata.update_metadata(params: {})
        expect(update[:created_by]).to eq(project.metadata[:created_by])
        expect(update[:created_on]).to eq(project.metadata[:created_on])
        expect(update[:updated_on]).to be_present
        expect(update[:updated_by]).to eq(current_user.uid)
      end
    end

    describe "#create" do
      let(:datacite_stub) { instance_double(PULDatacite, draft_doi: "aaabbb123") }
      before do
        allow(PULDatacite).to receive(:new).and_return(datacite_stub)
      end

      it "does not call out to draft a doi if the project is invalid" do
        project_metadata = described_class.new(current_user: current_user, project:)
        doi = project_metadata.create(params: {})
        project_metadata.create(params: {}) # doesn't call the doi service twice
        expect(datacite_stub).not_to have_received(:draft_doi)
        expect(doi).to be_nil
      end
      
      it "calls out to draft a doi" do
        sponsor =  FactoryBot.create(:user, uid: "abc")
        data_manager =  FactoryBot.create(:user, uid: "def")

        project_metadata = described_class.new(current_user: current_user, project:)
        params = {data_sponsor: "abc", data_manager: "def", departments: "dep", directory: "dir", title: "title abc", description: "description 123" }
        doi = project_metadata.create(params:)
        project_metadata.create(params: {}) # doesn't call the doi service twice
        expect(datacite_stub).to have_received(:draft_doi)
        expect(doi).to eq("aaabbb123")
        expect(project.reload.metadata[:project_id]).to eq("aaabbb123")
      end

      it "Creates a Provenance Event: Submission" do
        sponsor =  FactoryBot.create(:user, uid: "abc")
        data_manager =  FactoryBot.create(:user, uid: "def")
        data_sponsor = User.find_by(uid: "abc")
        project_metadata = described_class.new(current_user: current_user, project:)
        params = {data_sponsor: "abc", data_manager: "def", departments: "dep", directory: "dir", title: "title abc", description: "description 123" }
        doi = project_metadata.create(params:)
        project_metadata.create(params: {}) # doesn't call the doi service twice
        
        project.reload
        expect(project.provenance_events.count).to eq 2
        submission_event = project.provenance_events.first #testing the Submission Event
        expect(submission_event.event_type).to eq ProvenanceEvent::SUBMISSION_EVENT_TYPE
        expect(submission_event.event_person).to eq current_user.uid
        expect(submission_event.event_details).to eq "Requested by #{data_sponsor.display_name_safe}"
        
        status_update_event = project.provenance_events.last #testing the Status Update Event when the project is first submitted, #TODO: will need a separate test for when a project is approved by an admin
        expect(status_update_event.event_type).to eq ProvenanceEvent::STATUS_UPDATE_EVENT_TYPE
        expect(status_update_event.event_person).to eq current_user.uid
        expect(status_update_event.event_details).to eq "The Status of this project has been set to pending"
      end


      it "does not call out to draft a doi if one isalready set" do
        project.metadata_json["project_id"] = "aaabbb123"
        project_metadata = described_class.new(current_user: current_user, project:)
        doi = project_metadata.create(params: {})
        expect(datacite_stub).not_to have_received(:draft_doi)
        expect(doi).to eq("aaabbb123")
      end
    end
  end
end
