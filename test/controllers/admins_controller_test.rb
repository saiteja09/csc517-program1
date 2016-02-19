require 'test_helper'

class AdminsControllerTest < ActionController::TestCase
  test "should get index" do
    session[:user_id] = Admin.first.id
    get :index
    assert_response :success
  end

end
