# frozen_string_literal: true
require "rails_helper"

RSpec.describe ProjectAccumulator, connect_to_mediaflux: true, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:session_id) { user.mediaflux_session }
  let(:project_in_mediaflux) { FactoryBot.create(:project_with_doi, status: Project::APPROVED_STATUS) }

  describe "#create!" do
    it "creates accumulators for the project" do
      project_id = ProjectMediaflux.create!(session_id: user.mediaflux_session, project: project_in_mediaflux)
      project_accumulators = described_class.new(project: project_in_mediaflux, session_id: session_id)
      project_accumulators.create!
      metadata = Mediaflux::Http::AssetMetadataRequest.new(session_token: session_id, id: project_id).metadata

      expect(metadata[:accum_names].map(&:to_s)).to include("accum-count")
      expect(metadata[:accum_names].map(&:to_s)).to include("accum-size")
      expect(metadata[:accum_names].map(&:to_s)).to include("accum-store-size")
    end

    it "does not create accumulators if they already exist" do
      ProjectMediaflux.create!(session_id: user.mediaflux_session, project: project_in_mediaflux)
      project_accumulators = described_class.new(project: project_in_mediaflux, session_id: session_id)
      project_accumulators.create!

      expect(project_accumulators.create!).to eq(true)
    end
  end

  describe "#validate" do
    it "returns true if the collection has the expected accumulators" do
      project_id = ProjectMediaflux.create!(session_id: user.mediaflux_session, project: project_in_mediaflux)
      project_accumulators = described_class.new(project: project_in_mediaflux, session_id: session_id)
      project_accumulators.create!
      expect(project_accumulators.validate).to eq(true)
    end

    it "returns an array of accumulators if the collection does not have all expected accumulators" do
      project_id = ProjectMediaflux.create!(session_id: user.mediaflux_session, project: project_in_mediaflux)
      expect(described_class.new(project: project_in_mediaflux, session_id: session_id).validate).to be_a(Array)
    end
  end
end
