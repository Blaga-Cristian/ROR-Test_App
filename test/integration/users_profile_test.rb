require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @manager = users(:archer)
    @admin = users(:lana)
    @other_user = users(:malory)
  end

  test "should have right display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'div.pagination'
    @user.user_entries.paginate(page: 1).each do |entry|
      assert_match  entry.format_distance, response.body
      assert_match  entry.format_time, response.body
      assert_match  entry.format_date, response.body
    end
  end

  test "should have right to delete or edit" do
    log_in_as(@user)
    get user_path(@user)
    @user.user_entries.paginate(page: 1).each do |entry|
      assert_select 'a[href=?]', edit_user_entry_path(entry)
      assert_select 'a[href=?][data-method=delete]', user_entry_path(entry)
    end

    log_in_as(@admin)
    get user_path(@user)
    @user.user_entries.paginate(page: 1).each do |entry|
      assert_select 'a[href=?]', edit_user_entry_path(entry)
      assert_select 'a[href=?][data-method=delete]', user_entry_path(entry)
    end
  end

  test "should not be able to edit or delete" do
    log_in_as(@other_user)
    get user_path(@user)
    @user.user_entries.paginate(page: 1).each do |entry|
      assert_select 'a[href=?]', edit_user_entry_path(entry), count: 0
      assert_select 'a[href=?][data-method=delete]', user_entry_path(entry), count: 0
    end
  end
end
