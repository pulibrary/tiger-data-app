# frozen_string_literal: true
require "sidekiq"

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  # TODO: why does this cause the servers to break?
  # include Sidekiq::Job
end
