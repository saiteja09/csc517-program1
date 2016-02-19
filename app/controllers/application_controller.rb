# Base application controller.
# Defines global actions that take place for each page load
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  # Force login
  before_action :require_auth

  # Helper method for returning the currently authenticated users
  helper_method :authenticated?
  def authenticated?
    @auth_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
  end

  # Convert a string parameter to boolean
  helper_method :to_bool
  def to_bool (string)
    begin
      Integer(string) == 1 ? true : false
    rescue
      false
    end
  end

  # Method for requiring authentication
  def require_auth
    redirect_to login_path unless authenticated?
  end

  # Require that a users is authenticated as a student
  def require_student
    redirect_to root_path unless @auth_user && @auth_user.type == 'Student'
  end

  # Require a users to be a student or admin
  def require_student_or_admin
    redirect_to root_path unless @auth_user && ['Student', 'Admin'].include?(@auth_user.type)
  end

  def require_instructor
    redirect_to root_path unless @auth_user && @auth_user.type == 'Instructor'
  end

  # Require a user to be a Student or Instructor
  def require_student_or_instructor
    redirect_to root_path unless @auth_user && ['Student', 'Instructor'].include?(@auth_user.type)
  end

  def require_admin
    redirect_to root_path unless @auth_user.type == 'Admin'
  end
end
