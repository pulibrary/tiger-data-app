# frozen_string_literal: true
require "rails_helper"

RSpec.describe Users::OmniauthCallbacksController do
  before { request.env["devise.mapping"] = Devise.mappings[:user] }

  context "with project sponsor user" do
    let(:project_sponsor) { FactoryBot.create(:project_sponsor) }
    it "redirects to home page with notice" do
      allow(User).to receive(:from_cas) { project_sponsor }
      get :cas
      expect(response).to redirect_to(root_path)
      expect(flash.notice).to eq("Welcome, #{project_sponsor.given_name}")
    end
  end

  context "uknown user" do
    it "redirects to home page with alert" do
      allow(User).to receive(:from_cas) { FactoryBot.create(:user) }
      get :cas
      expect(response).to redirect_to(root_path)
      expect(flash.notice).to eq("TigerData is coming soon; Access is currently limited.")
    end
  end

  context "non-CAS user" do
    it "redirects to home page with alert" do
      allow(User).to receive(:from_cas) { nil }
      get :cas
      expect(response).to redirect_to(root_path)
      expect(flash.alert).to eq("You are not a recognized CAS user.")
    end
  end
end
