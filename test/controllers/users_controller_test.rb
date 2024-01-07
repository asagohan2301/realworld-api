require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create user" do
    assert_difference("User.count") do
      post api_users_url, params: { "user":{ "email":"test@mail", "password":"test-password", "username":"test-name" } }
    end
    assert_response :created
  end

  test "should not create user with invalid params" do
    assert_no_difference("User.count") do
      post api_users_url, params: { "user":{ "email":"", "password":"", "username":"" } }
    end
    assert_response :unprocessable_entity
  end
end
