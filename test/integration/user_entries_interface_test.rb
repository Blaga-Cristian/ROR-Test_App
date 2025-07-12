require "test_helper"

class UserEntriesInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "entries interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    
    time = 100
    distance = 100
    date = Time.zone.now

    assert_no_difference 'UserEntry.count' do
      post user_entries_path, params: { user_entry: { 
            time: time, 
            distance: -1, 
            date: date } }
    end

    assert_no_difference 'UserEntry.count' do
      post user_entries_path, params: { user_entry: {
            time: -1,
            distance: distance,
            date: date } }
    end

    assert_difference 'UserEntry.count', 1 do
      post user_entries_path, params: { user_entry: {
            time: time,
            distance: distance,
            date: date } }
    end
    assert_redirected_to root_url
    follow_redirect!

    entry = UserEntry.new(time: time, distance: distance, date: date)
    assert_match entry.format_time, response.body
    assert_match entry.format_distance, response.body
    assert_match entry.format_date, response.body
  end

  test "entry stat" do
    log_in_as(@user)
    get root_url
    assert_match "Entries (#{@user.user_entries.count})", response.body
    @user.user_entries.create!(time: 100, distance: 100, date: Time.zone.now)
    get root_path
    assert_match "Entries (#{@user.user_entries.count})", response.body
  end

  test "filter should work" do
    log_in_as(@user)
    from = 3.days.ago.beginning_of_day
    to = Time.zone.today
    get root_url, params: { from: from.to_s, to: to.to_s }
    first_page_of_entries = @user.user_entries.paginate(page: 1)
    first_page_of_entries.each do |entry|
      if from <= entry.date && entry.date <= to
        assert_select "a[href=?]", user_entry_path(entry)
      end
    end
  end

  test "weekly stats should show correct data" do
    log_in_as(@user)
    get weekly_report_path
    stats = UserEntry.weekly_stats(@user)
    stats.each do |key, value|
      assert_match "#{value[:average_speed]}", response.body
      assert_match "#{value[:total_distance]}", response.body
    end
  end


end
