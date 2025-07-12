require "test_helper"

class UsersShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "should be redirected if user is not activated" do
    post users_path, params: { user: { 
      name: "Cristi",
      email: "cristiblaga2004@gmail.com",
      password: "password",
      password_confirmation: "password" } }
    user = User.find_by(email: "cristiblaga2004@gmail.com")
    log_in_as(@user)
    get user_path(user)
    assert_redirected_to root_url
  end

end
