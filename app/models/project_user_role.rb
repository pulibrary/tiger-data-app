# frozen_string_literal: true
class ProjectUserRole < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :role
end
