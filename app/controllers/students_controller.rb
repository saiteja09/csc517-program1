# Controller for Student users
class StudentsController < ApplicationController
  # Don't require authentication for creating an account
  skip_before_action :require_auth

  # Render and return a form for creating a new Student
  def new
    @student = Student.new
  end

  # Create a new user account
  def create
    student_attrs = params.require(:student).permit(:name, :email, :password)
    conf = params.require(:student).permit(:confirm_password)

    begin
      @student = Student.create(student_attrs) unless student_attrs[:password] != conf[:confirm_password]

      if @student.id
        session[:user_id] = @student.id
        return redirect_to root_path
      end

    rescue

    end

    redirect_to new_student_path
  end
end
