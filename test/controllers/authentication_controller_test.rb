require 'test_helper'

class AuthenticationControllerTest < ActionController::TestCase

  # Login Page
  test "An unauthenticated user can access the login page" do
    # Make the request
    get :new

    # Verify
    assert_response :success
    assert_template :new
  end

  # Login
  test "A user may log in with a correct email/password" do
    # Get a user
    user = users :one

    # Send the login request
    post :create, session: { email: user.email, password: 'password' }

    # Verify logged in
    assert_equal user.id, session[:user_id]
    assert_redirected_to root_path
  end

  # Invalid Login - Email
  test "A user may not log in with an incorrect email" do
    # Send the login request
    post :create, session: { email: nil, password: 'password' }

    # Verify not logged in
    assert_nil session[:user_id]
    assert_redirected_to login_path
  end

  # Invalid Login - Password
  test "A user may not log in with an incorrect password" do
    # Get a user
    user = users :one

    # Send the login request
    post :create, session: { email: user.email, password: nil }

    # Verify not logged in
    assert_nil session[:user_id]
    assert_redirected_to login_path
  end

  # Logout
  test "A user may log out" do
    # Get a user and log in
    user = users :one
    session[:user_id] = user.id

    # Send the request
    delete :destroy

    # Verify logout
    assert_nil session[:user_id]
    assert_redirected_to login_path
  end
end
