require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  
  def setup
    @user = users(:michael)
    remember(@user)
  end

  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test "current user entries returns correct entries" do
    assert_equal @user.user_entries.paginate(page: 1), current_user_entries

    from = 3.days.ago.beginning_of_day
    to = Time.zone.today

    params[:from] = from.to_s 
    
    assert_equal @user.user_entries.paginate(page: 1), current_user_entries
    
    params[:to]   = to.to_s     

    current_user_entries.each do |entry|
      assert entry.date <= to
      assert from <= entry.date
    end

  end 

end
