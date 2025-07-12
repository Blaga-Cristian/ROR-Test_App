require "test_helper"

class UserEntriesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @manager = users(:archer)
    @admin = users(:lana)
    @other_user = users(:malory)
    @entry = user_entries(:michael_run_morning)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'UserEntry.count' do
      post user_entries_path, params: { user_entry: { 
        time: 100,
        distance: 1000,
        date: Time.zone.now } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'UserEntry.count' do
      delete user_entry_path(@entry)
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    assert_no_difference 'UserEntry.count' do
      patch user_entry_path(@entry), params: { user_entry: {
        time: 100,
        distance: 1000,
        date: Time.zone.now } }
    end
    assert_redirected_to login_url
  end

  test "other user cant change" do
    log_in_as(@other_user)
    
    assert_no_difference 'UserEntry.count' do
      patch user_entry_path(@entry), params: { user_entry: {
        time: 100,
        distance: 1000,
        date: Time.zone.now } }
    end

    assert_no_difference 'UserEntry.count' do
      delete user_entry_path(@entry)#, params: { user_entry: {
        #time: 100,
        #distance: 1000,
        #date: Time.zone.now } }
    end

  end

  test "admin can change" do
    log_in_as(@admin)

    time = 100
    distance = 1000
    date = Time.zone.now

    patch user_entry_path(@entry), params: { user_entry: {
        time: time, 
        distance: distance,
        date: date } }
    
    @entry.reload
    assert_equal time, @entry.time
    assert_equal distance, @entry.distance
    assert_in_delta date.to_i, @entry.date.to_i, 1

    assert_difference 'UserEntry.count', -1 do
      delete user_entry_path(@entry)
    end

  end

  test "user can change" do
    log_in_as(@user)

    time = 100
    distance = 1000
    date = Time.zone.now

    patch user_entry_path(@entry), params: { user_entry: {
        time: time, 
        distance: distance,
        date: date } }
    
    @entry.reload
    assert_equal time, @entry.time
    assert_equal distance, @entry.distance
    assert_in_delta date.to_i, @entry.date.to_i, 1

    assert_difference 'UserEntry.count', -1 do
      delete user_entry_path(@entry)#, params: { user_entry: {
        #time: 100,
        #distance: 1000,
        #date: Time.zone.now } }
    end
  end

  test "post should cause a turbo_stream response" do
    log_in_as(@user)
    get root_url
    
    assert_difference 'UserEntry.count', 1 do
      post user_entries_path(format: :turbo_stream), params: { user_entry: {
          time: 100,
          distance: 100,
          date: Time.zone.now } }
    end
    
    assert_response :success
    assert_match "text/vnd.turbo-stream.html", response.content_type

    entry = @user.user_entries.first

    assert_difference 'UserEntry.count', -1 do
      delete user_entry_path(entry, format: :turbo_stream)
    end

    assert_response :success
    assert_match "text/vnd.turbo-stream.html", response.content_type
  end


end
