# Authentication controller for users login/logout
class AuthenticationController < ApplicationController
  # Don't require login for Authentication
  skip_before_action :require_auth

  # Login page
  def new

  end

  # Authenticate users
  def create
    attrs = params[:session]
    @user = User.find_by_email attrs[:email]
    if @user && @user.authenticate(attrs[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to login_path
    end
  end

  # Log out
  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end
