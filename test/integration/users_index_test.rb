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
    end

    assert_difference 'User.count', -1 do
      delete user_path(@user_1)
    end

    log_in_as(@admin)
    assert_difference 'User.count', -1 do
      delete user_path(@user_2)
    end
  end


end
