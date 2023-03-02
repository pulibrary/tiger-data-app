# frozen_string_literal: true
class DashboardsController < ApplicationController
  def show
    # TODO: Is there a better way to do this efficiently in a single SQL statement?
    allowed_roles = current_user.allowed_roles.map(&:role)
    matching_roles = allowed_roles.filter { |role| clean_for_url(role.name) == params[:role] }
    if matching_roles.empty?
      render "/access_denied", status: :forbidden
    else
      @role = matching_roles[0]
      role_url_name = clean_for_url(@role.name)
      render "/dashboards/#{role_url_name}"
    end
  end
end

def clean_for_url(messy_string)
  messy_string.downcase.gsub(/\W/, "-")
end