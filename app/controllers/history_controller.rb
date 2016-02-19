class HistoryController < ApplicationController


  def index
    if @auth_user.type == 'Instructor'
      @courses = Course.joins(:instructor).where users: {id: @auth_user}
    elsif (@auth_user.type == "Admin")
      @courses = Course.where status: true
    end


    if params[:id] != nil
      @users = User.joins(:histories).where histories: {course_id: params[:id], is_current: true}
    #elsif params[:format] != nil
     # @users = User.joins(:histories).where histories: {course_id: params[:format], is_current: true}
      #params[:id] = params[:format]
    end

  end

  def create

  end


  def show
    @sd = 1
  end

  def destroy
    history = History.find_by_id params[:id]
    if history
      history.is_current = false
      history.save
      if(params[:course_id] == nil)
        redirect_to course_path(history.course)
      else
        redirect_to history_path(:id => params[:course_id])
      end
    else
      redirect_to root_path
    end
  end
end
