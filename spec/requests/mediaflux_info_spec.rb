# frozen_string_literal: true
require "rails_helper"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/mediaflux_info", connect_to_mediaflux: true, type: :request do
  describe "GET /index" do
    it "renders a successful response" do
      get mediaflux_info_index_path
      expect(response).to be_redirect
    end

    context "logged in user" do
      let(:user) { FactoryBot.create(:user, uid: "pul123") }
      let(:mediaflux_url) { "http://mflux-ci.lib.princeton.edu/__mflux_svc__" }

      before do
        sign_in user
      end

      it "renders a successful response" do
        get mediaflux_info_index_path
        expect(response).to be_successful
        expect(response.parsed_body).to include("4.16.047")
      end
    end
  end
end
