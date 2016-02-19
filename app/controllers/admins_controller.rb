class AdminsController < ApplicationController
  # Require admin status to access any action in the admins controller
  before_action :require_admin

  # List all admins
  def index
    @admins = Admin.filter
  end

  # Display a single admin.
  def show
    # Find the details of the admin requested
    @display_admin = Admin.find_by_id params[:id]
  end

  # Request the creation page for an admin
  def new
    @admin = Admin.new
  end

  # Create a new admin
  def create
    # Instantiate a new object using form parameters
    attrs = params.require(:admin).permit(:name, :email, :password)
    @admin = Admin.create(attrs) unless params[:admin][:password] != params[:admin][:confirm_password]

    # Save the object
    if @admin
      # If save succeeds, redirect to the index action
      redirect_to admins_path
    else
      # If save fails, redisplay the form so user can fix problems
      @admin = Admin.new
      render new_admin_path
    end
  end

  # Get the deletion confirmation page for an admin
  def delete
    @admin = Admin.find_by_id params[:id]
  end

  # Delete an admin, permanently!
  def destroy
    admin = Admin.find_by_id params[:id]

    if admin.deletable && admin.id != session[:user_id]
      admin.destroy
    end

    redirect_to admins_path
  end

end
