# frozen_string_literal: true
require "rails_helper"

RSpec.describe WelcomeController, stub_mediaflux: true do
  it "renders the index page" do
    get :index
    expect(response).to render_template("index")
  end
end
