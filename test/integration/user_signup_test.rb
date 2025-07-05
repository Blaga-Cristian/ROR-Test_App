require "test_helper"

class UserSignupTest < ActionDispatch::IntegrationTest
  
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
    assert_template 'users/show'
    assert_not flash.empty?
  end

end
