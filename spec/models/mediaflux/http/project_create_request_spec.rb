# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mediaflux::Http::ProjectCreateRequest, type: :model do
  let(:mediflux_url) { "http://mediaflux.example.com:8888/__mflux_svc__" }

  let(:create_response) do
    filename = Rails.root.join("spec", "fixtures", "files", "asset_create_response.xml")
    File.new(filename).read
  end

  describe "#id" do

    it "sends the metadata to the server", connect_to_mediaflux: true do
      data_user_ro = FactoryBot.create :user
      data_user_rw = FactoryBot.create :user
      session_id =  data_user_ro.mediaflux_session

      created_on = Time.current.in_time_zone("America/New_York").iso8601
      project = FactoryBot.create :project, data_user_read_only: [data_user_ro.uid], data_user_read_write: [data_user_rw.uid], created_on: created_on, 
                                            project_id: "abc/123", project_directory: "testasset"
      create_request = described_class.new(session_token: session_id, project:, namespace: Rails.configuration.mediaflux[:api_root_ns])
      expect(create_request.response_error).to be_blank
      expect(create_request.id).not_to be_blank
      req = Mediaflux::Http::AssetMetadataRequest.new(session_token: session_id, id: create_request.id)
      metadata  = req.metadata
      
      expect(metadata[:name]).to eq("testasset")
      expect(metadata[:title]).to eq(project.metadata[:title])
      expect(metadata[:description]).to eq(project.metadata[:description])
      expect(metadata[:data_sponsor]).to eq(project.metadata[:data_sponsor])
      expect(metadata[:departments]).to eq(project.metadata[:departments])
      # TODO Should really utilize MediafluxTime, but the time class upcases the date and does not zero pad the day
      expect(metadata[:created_on]).to eq(Time.zone.parse(created_on).strftime("%d-%b-%Y %H:%M:%S"))
      expect(metadata[:created_by]).to eq(project.metadata[:created_by])
      expect(metadata[:ro_users]).to eq([data_user_ro.uid])
      expect(metadata[:rw_users]).to eq([data_user_rw.uid])
    end
  end

  describe "#xml_payload" do
    it "creates the asset create payload" do
      project = FactoryBot.create :project, project_id: "abc-123", project_directory: "testasset"
      create_request = described_class.new(session_token: nil, project: project, namespace: nil)
      expected_xml = "<?xml version=\"1.0\"?>\n" \
      "<request xmlns:tigerdata=\"http://tigerdata.princeton.edu\">\n" \
      "  <service name=\"asset.create\">\n" \
      "    <args>\n" \
      "      <name>testasset</name>\n" \
      "      <meta>\n" \
      "        <tigerdata:project>\n" \
      "          <ProjectDirectory>#{project.project_directory}</ProjectDirectory>\n" \
      "          <Title>#{project.metadata[:title]}</Title>\n" \
      "          <Description>#{project.metadata[:description]}</Description>\n" \
      "          <Status>#{project.metadata[:status]}</Status>\n" \
      "          <DataSponsor>#{project.metadata[:data_sponsor]}</DataSponsor>\n" \
      "          <DataManager>#{project.metadata[:data_manager]}</DataManager>\n" \
      "          <Department>RDSS</Department>\n" \
      "          <Department>PRDS</Department>\n" \
      "          <CreatedOn>#{MediafluxTime.format_date_for_mediaflux(project.metadata[:created_on])}</CreatedOn>\n" \
      "          <CreatedBy>#{project.metadata[:created_by]}</CreatedBy>\n" \
      "          <ProjectID>abc-123</ProjectID>\n" \
      "          <StorageCapacity>\n" \
      "            <Size>500</Size>\n" \
      "            <Unit>GB</Unit>\n" \
      "          </StorageCapacity>\n" \
      "          <Performance Requested=\"standard\">standard</Performance>\n" \
      "          <Submission>\n" \
      "            <RequestedBy>#{project.metadata[:created_by]}</RequestedBy>\n" \
      "            <RequestDateTime>#{MediafluxTime.format_date_for_mediaflux(project.metadata[:created_on])}</RequestDateTime>\n" \
      "          </Submission>\n" \
      "          <ProjectPurpose>research</ProjectPurpose>\n" \
      "          <SchemaVersion>0.6.1</SchemaVersion>\n" \
      "        </tigerdata:project>\n" \
      "      </meta>\n" \
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
      project = FactoryBot.create :project, project_id: "abc-123", project_directory: "testasset"
      create_request = described_class.new(session_token: nil, project: project, namespace: nil)
      expected_xml = "<request xmlns:tigerdata='http://tigerdata.princeton.edu'><service name='asset.create'><name>testasset</name>" \
                     "<meta><tigerdata:project><ProjectDirectory>#{project.project_directory}</ProjectDirectory><Title>#{project.metadata[:title]}</Title>" \
                     "<Description>#{project.metadata[:description]}</Description><Status>#{project.metadata[:status]}</Status>" \
                     "<DataSponsor>#{project.metadata[:data_sponsor]}</DataSponsor><DataManager>#{project.metadata[:data_manager]}</DataManager>" \
                     "<Department>RDSS</Department><Department>PRDS</Department><CreatedOn>#{MediafluxTime.format_date_for_mediaflux(project.metadata[:created_on])}</CreatedOn>" \
                     "<CreatedBy>#{project.metadata[:created_by]}</CreatedBy><ProjectID>abc-123</ProjectID><StorageCapacity><Size>500</Size><Unit>GB</Unit></StorageCapacity>" \
                     "<Performance Requested='standard'>standard</Performance><Submission><RequestedBy>#{project.metadata[:created_by]}</RequestedBy>" \
                     "<RequestDateTime>#{MediafluxTime.format_date_for_mediaflux(project.metadata[:created_on])}</RequestDateTime></Submission>" \
                     "<ProjectPurpose>research</ProjectPurpose><SchemaVersion>0.6.1</SchemaVersion></tigerdata:project></meta>" \
                     "<collection cascade-contained-asset-index='true' contained-asset-index='true' unique-name-index='true'>true</collection>" \
                     "<type>application/arc-asset-collection</type></service></request>"
      expect(create_request.xtoshell_xml).to eq(expected_xml)
    end
  end
end
