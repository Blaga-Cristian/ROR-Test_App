require "test_helper"

class Api::V1::UserEntriesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @manager = users(:archer)
    @admin = users(:lana)
    @other_user = users(:malory)
    @entry = user_entries(:michael_run_morning)
  end

  test "should only allow logged in users" do
    get api_v1_user_entries_path
    assert_response :unauthorized
    post api_v1_user_entries_path
    assert_response :unauthorized
    get api_v1_user_entry_path(@entry)
    assert_response :unauthorized
    patch api_v1_user_entry_path(@entry)
    assert_response :unauthorized
    delete api_v1_user_entry_path(@entry)
    assert_response :unauthorized
  end

  test "index should show all entries" do
    get api_v1_user_entries_path, headers: api_log_in_header(@user)
    UserEntry.all.each do |entry|
      assert_includes json_response, api_entry_format(entry)
    end
  end

  test "should not create entry with invalid data" do
    assert_no_difference 'UserEntry.count' do
      post api_v1_user_entries_path, headers: api_log_in_header(@user), params: { user_entry: {
        time: -1,
        distance: -1,
        date: Time.zone.now } }
    end
    assert_response :unprocessable_entity
  end

  test "should create entry with valid data" do
    assert_difference 'UserEntry.count', 1 do
      post api_v1_user_entries_path, headers: api_log_in_header(@user), params: { user_entry: {
        time: 100,
        distance: 100,
        date: Time.zone.now } }
    end
    assert_response :created
  end

  test "should show entry" do
    get api_v1_user_entry_path(@entry), headers: api_log_in_header(@user)
    assert_equal json_response, api_entry_format(@entry)
  end

  test "user should not update other user entry" do
    patch api_v1_user_entry_path(@entry), headers: api_log_in_header(@other_user)
    assert_response :forbidden
  end

  test "user should be able to update own entry" do
    patch api_v1_user_entry_path(@entry), headers: api_log_in_header(@user), params: { user_entry: {
      time: 100,
      distance: 100,
      date: Time.zone.now } }
    assert_response :ok
  end

  test "admin should be able to update entry" do
    patch api_v1_user_entry_path(@entry), headers: api_log_in_header(@admin), params: { user_entry: {
      time: 100,
      distance: 100,
      date: Time.zone.now } }
    assert_response :ok
  end

  test "user cannot delete other user entry" do
    assert_no_difference 'UserEntry.count' do
      delete api_v1_user_entry_path(@entry), headers: api_log_in_header(@other_user)
    end
    assert_response :forbidden
  end

  test "user can delete own entry" do
    assert_difference 'UserEntry.count', -1 do
      delete api_v1_user_entry_path(@entry), headers: api_log_in_header(@user)
    end
    assert_response :no_content
  end

  test "admin can delete any entry" do
    assert_difference 'UserEntry.count', -1 do
      delete api_v1_user_entry_path(@entry), headers: api_log_in_header(@admin)
    end
    assert_response :no_content
  end

  test "my entries should show all entries" do
    get my_entries_api_v1_user_entries_path, headers: api_log_in_header(@user)
    @user.user_entries.each do |entry|
      assert_includes json_response, api_entry_format(entry)
    end
  end

  test "weekly report should show correct data" do
    get weekly_report_api_v1_user_entries_path, headers: api_log_in_header(@user)
    assert_equal json_response.count, UserEntry.weekly_stats(@user).count
  end

end
