class PostsController < ApplicationController
  # Begin definition of a new post
  def new
    begin
      @post = Post.new message: Message.find(params[:message_id])
    rescue
      redirect_to message_path
    end
  end

  # Create a new post
  def create
    # Grab the message
    message = Message.find params[:message_id]

    # Create the post
    post = Post.new params[:post].permit :content
    post.message = message
    post.user = @auth_user

    # Attempt to save and redirect
    if post.save
      redirect_to message_path(message)
    else
      redirect_to new_message_post_path
    end
  end
end
