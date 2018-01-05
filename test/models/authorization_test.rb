require 'test_helper'

class AuthorizationTest < ActiveSupport::TestCase
	def setup
	   @user = users(:michael)
	   # このコードは慣習的に正しくない
	   @authorization = Authorization.new(content: "Lorem ipsum", user_id: @user.id)
	 end

	 test "should be valid" do
	   assert @authorization.valid?
	 end

	 test "user id should be present" do
	   @micropost.user_id = nil
	   assert_not @micropost.valid?
	 end
end