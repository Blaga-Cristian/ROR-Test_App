require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @manager = users(:archer)
    @admin = users(:lana)
    @other_user = users(:user_1)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect udpate when not logged in" do
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect delete when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "managers should be able to delete users" do  
    log_in_as(@manager)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end

  test "admins should be able to delete users" do 
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end
  end

  test "delete by regular user is redirected" do
    log_in_as(@user)
    assert_no_difference 'User.count' do  
      delete user_path(@other_user)
      delete user_path(@manager)
      delete user_path(@admin)
    end
  end

end
