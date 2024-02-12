# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mediaflux::Http::IteratorRequest, type: :model do
  let(:mediaflux_url) { "http://mediaflux.example.com:8888/__mflux_svc__" }

  let(:query_response) do
    filename = Rails.root.join("spec", "fixtures", "files", "iterator_response1.xml")
    File.new(filename).read
  end

  describe "#result" do
    before do
      stub_request(:post, mediaflux_url)
        .with(body: "<?xml version=\"1.0\"?>\n<request>\n  <service name=\"asset.query.iterate\" session=\"secretsecret/2/31\">\n    " \
        "<args>\n      <id>123</id>\n    </args>\n  </service>\n</request>\n")
        .to_return(status: 200, body: query_response, headers: {})
    end

    it "returns asset information" do
      query_request = described_class.new(session_token: "secretsecret/2/31", iterator: "123", action: "get-values")
      result = query_request.result
      expect(result[:files][0].name).to eq "file1.txt"
      expect(result[:files][0].path).to eq "/td-demo-001/localbig-ns/localbig/file1.txt"
      expect(result[:files][0].size).to eq 141
      expect(result[:files].count).to eq 8
      expect(result[:complete]).to eq true
      expect(WebMock).to have_requested(:post, mediaflux_url)
    end
  end
end
