require "test_helper"

class UserEntryTest < ActiveSupport::TestCase

  def setup 
    @user = users(:michael)
    @entry = @user.user_entries.build(date: Time.zone.now, time: 100, distance: 1000)
  end

  test "should be valid" do
    assert @entry.valid?
  end

  test "user id should not be nil" do
    @entry.user_id = nil
    assert_not @entry.valid?
  end

  test "time should be valid" do
    @entry.time = -1
    assert_not @entry.valid?
    @entry.time = 0
    assert_not @entry.valid?
    @entry.time = 1
    assert @entry.valid?
  end

  test "date should be valid" do
    @entry.date = nil
    assert_not @entry.valid?
  end

  test "distance should be valid" do
    @entry.distance = -1
    assert_not @entry.valid?
    @entry.distance = 0
    assert_not @entry.valid?
    @entry.distance = 1
    assert  @entry.valid?
  end

  test "earliest should come first" do  
    UserEntry.all.each do |entry| 
      assert entry.date <= UserEntry.first.date
    end
  end

end
