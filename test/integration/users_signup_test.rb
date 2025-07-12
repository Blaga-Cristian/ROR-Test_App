require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    
    assert_no_difference 'User.count' do
      post users_path, params: { user: {  name: "",
                                          email: "example@gmail.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end

    assert_template 'users/new'
    assert_select   'div#error_explanation'
    assert_select   'div.alert.alert-danger'
  end

  test "valid signup information" do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: { user: {   name: "Cristi",
                                            email: "cristiblaga2004@gmail.com",
                                            password: "password",
                                            password_confirmation: "password" } }
    end

    follow_redirect!
    #assert_template 'static_pages/home'
    assert_not flash.empty?
  end

  test "valid signup information with account activation" do
    get signup_path
    
    assert_difference 'User.count', 1 do
     post users_path, params: { user: {   name: "Cristi",
                                          email: "cristiblaga2004@gmail.com",
                                          password: "password",
                                          password_confirmation: "password" } }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_redirected_to root_url(format: :html)
    follow_redirect!
    assert_not is_logged_in?
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: "invalid email")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    assert_redirected_to user
    follow_redirect!
    assert is_logged_in?
  end



end
