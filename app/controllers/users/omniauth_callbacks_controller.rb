# frozen_string_literal: true
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def cas
    @user = User.from_cas(request.env["omniauth.auth"])

    if @user.nil?
      redirect_to root_path
      flash.alert = "You are not a recognized CAS user."
    elsif @user.allowed_roles.empty?
      redirect_to root_path
      flash.notice = "TigerData is coming soon; Access is currently limited."
    else
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      flash.notice = "Welcome, #{@user.uid}"
    end
  end
end
