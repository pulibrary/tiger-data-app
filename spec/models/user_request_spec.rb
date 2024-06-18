# frozen_string_literal: true
require "rails_helper"

describe UserRequest, type: :model do
  let(:user_request) { described_class.create(user_id: user.id, project_id: project.id, job_id: job.job_id, completion_time: completion_time, state: state) }

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project) }
  let(:job) { ListProjectContentsJob.new }
  let(:completion_time) { Time.current.in_time_zone("America/New_York").iso8601 }
  let(:state) { UserRequest::PENDING }

  describe "#user_id" do
    it "has a user id" do
      expect(user_request.user.id).to be(user.id)
    end
  end

  describe "#project_id" do
    it "has a project id" do
      expect(user_request.project.id).to be(project.id)
    end
  end

  describe "#job_id" do
    it "has a job id" do
      expect(user_request.job_id).to eq(job.job_id)
    end
  end

  # TODO: TEST TYPE, REQUEST DETAILS

  describe "#created_at" do
    it "has a creation time" do
      expect(user_request.created_at).to be_instance_of(ActiveSupport::TimeWithZone)
    end
  end

  describe "#completion_time" do
    it "has a completion time" do
      expect(user_request.completion_time).to eq(completion_time)
    end
  end

  describe "#state" do
    it "has a state" do
      expect(user_request.state).to eq(state)
    end

    it "can be pending" do
      user_request.state = UserRequest::PENDING
      user_request.save
      expect(user_request.state).to eq(UserRequest::PENDING)
    end

    it "can be completed" do
      user_request.state = UserRequest::COMPLETED
      user_request.save
      expect(user_request.state).to eq(UserRequest::COMPLETED)
    end

    it "can be stale" do
      user_request.state = UserRequest::STALE
      user_request.save
      expect(user_request.state).to eq(UserRequest::STALE)
    end

    it "has an error if set to a non-standard value" do
      user_request.state = "foobar"
      expect(user_request.save).to be(false)
      expect(user_request.errors[:state]).to include("is not included in the list")
    end
  end
end
