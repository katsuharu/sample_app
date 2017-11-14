require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_path
    assert_response :success
  end


  test "name should be present" do
      @user.name = "     "
      assert_not @user.valid?
  end
end