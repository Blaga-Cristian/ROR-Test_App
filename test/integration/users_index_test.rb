require "test_helper"

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @manager = users(:archer)
    @admin = users(:lana)
    @user_1 = users(:user_1)
    @user_2 = users(:user_2)
  end


  test "user index layout" do 
    log_in_as(@manager)
    get users_path
    assert_select 'div.pagination'  
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user| 
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), test: 'delete'
    end

    assert_difference 'User.count', -1 do
      delete user_path(@user_1)
    end

    log_in_as(@admin)
    get users_path
    assert_select 'div.pagination'  
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user| 
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), test: 'delete'
    end

    assert_difference 'User.count', -1 do
      delete user_path(@user_2)
    end

  end

  test "index as non admins" do
    log_in_as(@user_1)
    get users_path
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select 'a[href=?]', user_path(user), text: 'delete', count: 0
    end
  end

  test "should redirect user if not logged in" do
    get users_path
    assert_redirected_to login_path
  end


end
