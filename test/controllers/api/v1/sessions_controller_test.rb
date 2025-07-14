require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end


  test "should not create session with invalid informaion" do
    post api_v1_login_path, params: { 
      email: "invalid@gmail.com",
      password: "password" }
    assert_response :unauthorized

    post api_v1_login_path, params: {
      email: @user.email,
      password: "invalid" }
    assert_response :unauthorized
  end 

  test "should create session with valid information" do
    post api_v1_login_path, params: {
      email: @user.email,
      password: "password" }
    assert_equal @user.id, Api::V1::AuthToken.decode(json_response[:token])&.dig('user_id')
    assert_response :ok
  end
  
end
