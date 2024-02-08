# frozen_string_literal: true
require "rails_helper"

RSpec.describe Mediaflux::Asset, type: :model do
  let(:file_asset) do
    Mediaflux::Asset.new(id: 123, name: "file.txt", path: "#{Rails.configuration.mediaflux['api_root_ns']}/project-1/photos/sunset.jpg", collection: false)
  end

  let(:folder_asset) do
    Mediaflux::Asset.new(id: 123, name: "photos", path: "#{Rails.configuration.mediaflux['api_root_ns']}/project-1/photos", collection: true)
  end

  describe "#path" do
    it "returns raw mediaflux values with the root namespace" do
      expect(file_asset.path).to eq file_asset.path
      expect(folder_asset.path).to eq folder_asset.path
    end
  end

  describe "#path_short" do
    it "handles files and folders correctly" do
      expect(file_asset.path_short).to eq "/project-1/photos/sunset.jpg"
      expect(folder_asset.path_short).to eq "/project-1/photos"
    end
  end

  describe "#path_only" do
    it "handles files and folders correctly" do
      expect(file_asset.path_only).to eq "/project-1/photos"
      expect(folder_asset.path_only).to eq "/project-1/photos"
    end
  end
end
