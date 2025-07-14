require "test_helper"

class Api::V1::PasswordResetsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "should not create reset for invalid email" do
    post api_v1_password_resets_path, params: { password_reset: {
      email: "invalid@gmail.com" } }
    assert_equal({ error: "Email address not found" }, json_response)
    assert_response :not_found
  end

  test "should create reset for valid email" do
    post api_v1_password_resets_path, params: { password_reset: {
      email: @user.email } }
    assert_response :no_content
  end
  
end
