# frozen_string_literal: true
require "rails_helper"

RSpec.describe User, type: :model do
  let(:access_token) { OmniAuth::AuthHash.new(provider: "cas", uid: "who", extra: { mail: "who@princeton.edu", givenname: "guess", sn: "who", pudisplayname: "Guess Who?" }) }

  describe "#from_cas" do
    it "returns a user object" do
      user = described_class.from_cas(access_token)
      expect(user).to be_a described_class
      expect(user.uid).to eq("who")
      expect(user.given_name).to eq("guess")
      expect(user.family_name).to eq("who")
      expect(user.display_name).to eq("Guess Who?")
    end
  end

  describe "users have roles" do
    describe "project sponsor" do
      let(:project_sponsor) { FactoryBot.create :project_sponsor }
      it "has a project sponsor role" do
        expect(project_sponsor.roles.first.name).to eq "project_sponsor"
      end
    end
  end
end
