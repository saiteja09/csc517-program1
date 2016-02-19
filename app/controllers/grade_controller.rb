class GradeController < ApplicationController

  def index

    if(@auth_user.type == "Instructor")
      @courses = Course.joins(:instructor).where users: {id: @auth_user}
    elsif (@auth_user.type == "Admin")
      @courses = Course.where status: true
    end
    if params[:id] != nil
      @users = User.joins(:histories).where histories: {course_id: params[:id], is_current: true}
      @histories = History.where course_id: params[:id], is_current: true
    end
  end

  def new
    @grades = Grade.new
  end

  def create

    #Update grade
    grade = Grade.new
    grade.gradeletter =  params[:grade]
    grade.history_id = params[:history_id]
    grade.save

    #update history
    history = History.find_by_id params[:history_id]
    history.update_attribute(:is_current, false)

    redirect_to grade_index_path(:id => params[:course_id])
  end

end
