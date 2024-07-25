# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mediaflux::AssetCreateRequest, connect_to_mediaflux: true, type: :model do
  let(:mediaflux_url) { "http://0.0.0.0:8888/__mflux_svc__" }
  let(:session_token) { Mediaflux::LogonRequest.new.session_token }
  let(:root_ns) { Rails.configuration.mediaflux["api_root_collection_namespace"] }        # /td-test-001
  let(:parent_collection) { Rails.configuration.mediaflux["api_root_collection_name"] }   # tigerdata
  let(:user) { FactoryBot.create(:user) }
  let(:approved_project) { FactoryBot.create(:approved_project) }
  let(:approved_project2) { FactoryBot.create(:approved_project) }

  let(:create_response) do
    filename = Rails.root.join("spec", "fixtures", "files", "asset_create_response.xml")
    File.new(filename).read
  end

  describe "#id" do
    it "creates a collection on the server" do
      Mediaflux::RootCollectionAsset.new(session_token: session_token, root_ns: root_ns, parent_collection: parent_collection).create
      session_id = User.new.mediaflux_session

      create_request = described_class.new(session_token: session_id, name: "testasset", namespace: Rails.configuration.mediaflux[:api_root_ns])
      expect(create_request.response_error).to be_blank
      expect(create_request.id).not_to be_blank
      req = Mediaflux::AssetMetadataRequest.new(session_token: session_id, id: create_request.id)
      metadata = req.metadata
      expect(metadata[:name]).to eq("testasset")
    end

    context "A collection within a collection" do
      before do
        approved_project.mediaflux_id = nil
        @mediaflux_id = ProjectMediaflux.create!(project: approved_project, session_id: user.mediaflux_session)
      end

      it "parses a metadata response" do
        create_request = described_class.new(session_token: user.mediaflux_session, name: "testasset", pid: @mediaflux_id)
        expect(create_request.id).to_not be_blank
        expect(a_request(:post, mediaflux_url).with do |req|
                 req.body.include?("<name>tigerdata</name>") &&
                 req.body.include?("<type>application/arc-asset-collection</type>")
               end).to have_been_made
      end
    end
  end

  describe "#xml_payload" do
    it "creates the asset create payload" do
      create_request = described_class.new(session_token: nil, name: "testasset")
      expected_xml = "<?xml version=\"1.0\"?>\n" \
      "<request>\n" \
      "  <service name=\"asset.create\">\n" \
      "    <args>\n" \
      "      <name>testasset</name>\n" \
      "      <collection cascade-contained-asset-index=\"true\" contained-asset-index=\"true\" unique-name-index=\"true\">true</collection>\n" \
      "      <type>application/arc-asset-collection</type>\n" \
      "    </args>\n" \
      "  </service>\n" \
      "</request>\n"
      expect(create_request.xml_payload).to eq(expected_xml)
    end
  end

  describe "#xtoshell_xml" do
    it "creates the asset create xml in a format that can be passed to xtoshell in aterm" do
      create_request = described_class.new(session_token: nil, name: "testasset")
      expected_xml = "<request><service name='asset.create'><name>testasset</name>" \
                     "<collection cascade-contained-asset-index='true' contained-asset-index='true' unique-name-index='true'>true</collection>" \
                     "<type>application/arc-asset-collection</type></service></request>"
      expect(create_request.xtoshell_xml).to eq(expected_xml)
    end
  end
end
