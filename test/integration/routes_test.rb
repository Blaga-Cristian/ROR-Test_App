require 'test_helper'


class RoutesTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end


  test "right layout links for not logged in user" do
    get root_url
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", signup_path
    assert_select "a[href=?]", login_path
  end

  test "right layout links for logged in user" do
    log_in_as(@user)
    get root_url
    assert_select "a[href=?]",  root_path, count: 3
    assert_select "a[href=?]",  help_path
    assert_select "a[href=?]",  about_path
    assert_select "a[href=?]",  contact_path
    assert_select "a[href=?]",  users_path
    assert_select "a[href=?]",  user_path(@user)
    assert_select "a[href=?]",  edit_user_path(@user)
    assert_select "a[href=?]",  weekly_report_path
    assert_select "a[href=?]",  logout_path(format: :html)
  end

end
