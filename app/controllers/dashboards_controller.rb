# frozen_string_literal: true
class DashboardsController < ApplicationController
  def show
    user_config = YAML.load_file("users.yaml")[current_user.uid]
    unless user_config
      render "/access_denied", status: :forbidden
      return
    end
  
    @allowed_roles = user_config["roles"]
    @role = params[:role]
    unless @allowed_roles.include?(@role)
      render "/access_denied", status: :forbidden
    else
      render "/dashboards/#{@role}"
    end
  end
end
