require "test_helper"

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @manager = users(:archer)
    @admin = users(:lana)
    @other_user = users(:malory)
  end

  test "create with invalid data" do
    post api_v1_signup_path, params: { user: {
      name: "",
      email: "",
      password: ""
      } }
    assert_match "error", response.body
    assert_response :unprocessable_entity

    post api_v1_signup_path, params: { user: { 
      name: "",
      email: "example@rails.com",
      password: "password"
    } }
    assert_match "error", response.body
    assert_response :unprocessable_entity
    
    post api_v1_signup_path, params: { user: {
      name: "Cristi" * 60,
      email: "example@rails.com",
      password: "password",
      password_confirmation: "password"
    } }
    assert_match "error", response.body
    assert_response :unprocessable_entity

    post api_v1_signup_path, params: { user: {
      name: "Cristi",
      email: "example@rails.com" * 20,
      password: "password",
      password_confirmation: "password"
    } }
    assert_match "error", response.body
    assert_response :unprocessable_entity

    post api_v1_signup_path, params: { user: {
      name: "Cristi",
      email: "example@rails.com",
      password: "pa",
      password_confirmation: "pasword"
    } }
    assert_match "error", response.body
    assert_response :unprocessable_entity
  end

  test "create with valid data" do
    assert_difference 'User.count', 1 do
      post api_v1_signup_path, params: { user: {
        name: "Cristi",
        email: "example@rails.com",
        password: "password",
        password_confirmation: "password" } }
    end
  end

  test "show index update destroy should only be accessbile to logged in users" do  
    get api_v1_users_path
    assert_equal({ error: 'Unauthorized' }, json_response)
    get api_v1_user_path(@user)
    assert_equal({ error: 'Unauthorized' }, json_response)
    patch api_v1_user_path(@user), params: { user: {
      name: "Cristi",
      email: "example@rails.com",
      password: "password",
      password_confirmation: "password" } }
    assert_equal({ error: 'Unauthorized' }, json_response)
    delete api_v1_user_path(@user)
    assert_equal({ error: 'Unauthorized' }, json_response)
  end

  test "index should show all users" do
    get api_v1_users_path, headers: api_log_in_header(@user)
    User.all.each do |user|
      assert_includes json_response, api_safe_format(user)
    end
  end

  test "show should work" do
    get api_v1_user_path(@other_user), headers: api_log_in_header(@user)
    assert_equal json_response, api_safe_format(@other_user)
  end

  test "update cannot be done by other user" do
    patch api_v1_user_path(@other_user), headers: api_log_in_header(@user), params: { user: {
      name: "New name",
      email: "new@gmail.com",
      password: "password",
      password_confirmation: "password" } }
    assert_equal json_response, { error: 'Not allowed' }
  end

  test "update can be done by manager" do
    patch api_v1_user_path(@other_user), headers: api_log_in_header(@manager), params: { user: {
      name: "New name",
      email: "new@gmail.com",
      password: "password",
      password_confirmation: "password" } }
    assert_response :ok
  end

  test "update can be done by admin" do
    patch api_v1_user_path(@other_user), headers: api_log_in_header(@admin), params: { user: {
      name: "New name",
      email: "new@gmail.com",
      password: "password",
      password_confirmation: "password" } }
    assert_response :ok
  end

  test "destroy cannot be done by other user" do
    assert_no_difference 'User.count' do
      delete api_v1_user_path(@other_user), headers: api_log_in_header(@user)
    end
    assert_response :forbidden
  end

  test "destroy can be done by manager" do
    assert_difference 'User.count', -1 do
      delete api_v1_user_path(@other_user), headers: api_log_in_header(@manager)
    end
    assert_response :no_content
  end
  
  test "destroy can be done by admin" do
    assert_difference 'User.count', -1 do
      delete api_v1_user_path(@other_user), headers: api_log_in_header(@manager)
    end
    assert_response :no_content
  end
end
