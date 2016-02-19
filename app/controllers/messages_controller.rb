class MessagesController < ApplicationController
  before_action :require_student_or_instructor
  before_action :restrict_to_participants, only: [:show]
  before_action :restrict_to_student, only: [:new, :create]
  before_action :require_student, only: [:create]

  # Redirect to the messages page if the user
  # is not a participant in the message.
  def restrict_to_participants
    # Get the message
    if (message = Message.find_by_id params[:id])
      # Return if the user is in the message
      return if [message.student, message.instructor].include? @auth_user
    end

    # Redirect to messages
    redirect_to messages_path
  end

  # Restrict creation of a message to a student
  # who belongs to a course taught by the instructor
  def restrict_to_student
    # Get the instructor the message is headed to
    instructor = Instructor.find_by_id params[:user_id]

    # Get all instructors that this student has been taught by.
    #
    # SELECT * FROM users JOIN courses ON courses.instructor_id = users.id JOIN histories ON
    # histories.course_id = courses.id WHERE users.type = 'Instructor' AND histories.student_id = id
    #
    # This translates to selecting all instructors that have taught a course that is associated
    # with a history that belongs to the student.
    instructors =  Instructor.joins(courses: :histories).where(histories: {user: @auth_user})

    # Redirect if the target instructor is not in the list of instructors
    redirect_to messages_path unless instructors.include? instructor
  end

  # Display all messages for a user.
  def index
    if @auth_user.type == 'Student'
      @messages = Message.where student: @auth_user
    else
      @messages = Message.where instructor: @auth_user
    end
  end

  # Display a single message and all posts
  def show
    if (@message = Message.find_by_id params[:id])
      @posts = Post.where(message: @message).order :created_at
    else
      redirect_to messages_path
    end
  end

  # Begin creation of a new message
  def new
    @message = Message.new
  end

  # Create a new message
  def create
    # Get the other user
    other_user = User.find_by_id params[:user_id]

    # Determine instructor and student
    instructor = @auth_user.type == 'Instructor' ? @auth_user : other_user
    student = instructor == other_user ? @auth_user : other_user

    # Create the message
    message = Message.create do |m|
      m.subject = params[:subject]
      m.instructor = instructor
      m.student = student
    end

    # Create the post
    Post.create do |p|
      p.message = message
      p.user = @auth_user
      p.content = params[:content]
    end

    # Redirect to message
    redirect_to message_path(message)
  end
end
