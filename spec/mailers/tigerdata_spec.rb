# frozen_string_literal: true
require "rails_helper"

RSpec.describe TigerdataMailer, type: :mailer do
  let(:project) { FactoryBot.create :project }

  it "Sends project creation reuests" do
    expect { described_class.with(project: project).project_creation.deliver }.to change { ActionMailer::Base.deliveries.count }.by(1)
    mail = ActionMailer::Base.deliveries.last

    expect(mail.subject).to eq "Project Creation Request"
    expect(mail.to).to eq ["test@example.com"]
    expect(mail.cc).to eq ["test_to@example.com"]
    html_body = mail.body.to_s
    expect(html_body).to have_content(project.title)
    project.metadata.keys.each do |field|
      value = project.metadata[field]
      value = value.join(", ") if value.is_a? Array
      expect(html_body).to have_content(value)
    end
  end
end