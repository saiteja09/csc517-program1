class CoursesController < ApplicationController

  # Require a student account to access current courses
  before_action :require_student, only: [:my]

  # Require admin account to add a course
  before_action :require_admin, only: [:new, :create, :delete, :destroy, :edit, :update]

  # Display all courses for a user
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

  # Add a new course to the system
  def new
    @course = Course.new
  end

  # Create a new course
  def create
    # Instantiate a new object using form parameters
    attrs = params.permit(:coursenumber, :title, :description, :start_date, :end_date, :created_at, :updated_at, :status, :active, :inactivation_request)
    @instructor = Instructor.find_by_email params[:email]

    attrs[:instructor] = @instructor
    if @instructor
      @course = Course.create(attrs)
      redirect_to courses_path
    else
      @course = Course.new
      render new_course_path
    end
  end

  # Display courses belonging to a student
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

  # Set a request for course to be inactive.
  def inactivate
    @courses = Course.joins(:instructor).where users: {id: @auth_user}

    if(params[:id] != nil && params[:action] == 'course_inactive' && params[:inactivated] != 'true')
      course = Course.find_by_id(params[:id])
      course.inactivation_requested= true
      course.save!

      redirect_to course_inactive_path(:inactivated => true, :id =>params[:id])
    end
  end

  #toggle course status
  def toggleactivation
    courseid = params[:format]
    course = Course.find_by_id params[:format]

    if course.inactivation_requested== true and course.status == true
      course.inactivation_requested= false
      course.status = false
      course.save!
    elsif course.inactivation_requested== false and course.status == false
      course.status = true
      course.save!
    end

    redirect_to courses_path

  end


  # Edit the details of the course
  def edit
    @course = Course.find_by_id params[:id]
  end

  def update
    attrs = params.permit(:coursenumber, :title, :description, :start_date, :end_date, :created_at, :updated_at, :status, :active, :inactivation_request)
    @instructor = Instructor.find_by_email params[:email]
    attrs[:instructor] = @instructor

    @course = Course.find_by_id params[:id]

    if @instructor
      @course.update(attrs)
      redirect_to courses_path
    else
      redirect_to edit_course_path(@course)
    end
  end

  # Delete the course.
  def delete
    @course = Course.find_by_id params[:id]
  end

  def destroy
    begin
      course = Course.find_by_id params[:id]
      course.destroy
      redirect_to courses_path
    rescue
      flash[:notice] = "Course cannot be deleted as one or more students are registered for it"
      redirect_to courses_path
    end

  end


end
