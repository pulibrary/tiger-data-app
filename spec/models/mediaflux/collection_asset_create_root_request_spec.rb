# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mediaflux::CollectionAssetCreateRootRequest, type: :model, connect_to_mediaflux: true do
  let(:session_token) { Mediaflux::LogonRequest.new.session_token }
  let(:namespace_root) { Rails.configuration.mediaflux["api_root_collection_namespace"] }
  let(:name) { FFaker::InternetSE.company_name_single_word + Random.rand(1000).to_s }

  it "creates a collection asset only if it does not exist already" do
    subject = described_class.new(session_token: session_token, namespace: namespace_root, name: name)
    expect(subject.id.to_i).not_to eq 0

    subject = described_class.new(session_token: session_token, namespace: namespace_root, name: name)
    expect(subject.id.to_i).to eq 0
    expect(subject.response_error[:message].include?("already contains")).to be true
  end
end
