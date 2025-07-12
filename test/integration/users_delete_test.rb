require "test_helper"

class UsersDeleteTest < ActionDispatch::IntegrationTest

  def setup
    @normal_user = users(:michael)
    @user_manager = users(:archer)
    @admin = users(:lana)
  end

  test "should redirect if not logged in" do
    delete user_path(@normal_user)
    assert_redirected_to login_path
  end

  test "should redirect if not have right to delete" do
    log_in_as(@normal_user)
    delete user_path(@user_manager)
    assert_redirected_to root_url
  end

  test "admin can delete" do
    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@normal_user)
    end
    assert_not flash.empty?
  end

  test "manager can delete" do
    log_in_as(@user_manager)
    assert_difference 'User.count', -1 do
      delete user_path(@normal_user)
    end
    assert_not flash.empty?
  end

end
