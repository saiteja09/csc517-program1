class CoursesController < ApplicationController

  # Require a student account to access
  before_action :require_student, only: [:index, :my]

  # Display all courses
  def index
    if params[:like]
      # Wildcard matching
      like = "%#{params[:like]}%"

      # Filter courses
      @courses = Course.joins(:instructor).where('(coursenumber LIKE :like ' +
                                ' OR title LIKE :like' +
                                ' OR users.name LIKE :like' +
                                ' OR description LIKE :like)' +
                                ' AND status = :status',
                                :like => like, :status => params[:status])
    else
      @courses = Course.all
    end
  end

  # Display courses belonging to a person
  def my
    # Find all courses for a users
    all = Course.joins(:histories).where histories: {user: @auth_user}

    # Split into current and past courses
    @current = all.where histories: {is_current: true}
    @past = all.where histories: {is_current: false}
  end

  # Display a single course.
  def show
    # Find the course, history, and student enrollment request, if any
    @course = Course.find_by_id params[:id]
    @history = History.find_by(course: @course, user: @auth_user) if @course
    @grade = Grade.find_by(history: @history) if @history
    @request = EnrollmentRequest.find_by(course: @course, student: @auth_user, is_fulfilled: false) unless @history

    # Redirect if course does not exist
    redirect_to root_path unless @course
  end
end
