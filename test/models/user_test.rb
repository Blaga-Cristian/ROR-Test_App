require "test_helper"

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "example@rails.com",
                      password: "password",
                      password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should not accept invalid name" do
    @user.name = "      "
    assert_not @user.valid?
    @user.name = "a" * 51
    assert_not @user.valid?
  end
 
  test "should not accept invalid email" do
    @user.email = "     "
    assert_not @user.valid?
    @user.email = "a" * 256
    assert_not @user.valid?
    
    invalid_emails = [
		  "plainaddress",
		  "@missinglocal.com",
		  "user@com",
		  "user name@example.com",
		  "user@exa mple.com",
		  "user@example.com.",
		  "user@exam_ple.com",
		  "user@localhost"
		]		
		
    invalid_emails.each do |email|
      @user.email = email
      assert_not @user.valid?, "#{email} should not be valid"
    end
  end

  test "should not allow duplicate users" do
    duplicate_user = @user.dup
    @user.save
    assert_not duplicate_user.valid?
  end

  test "emails should be saved as lower_case" do
    mixed_case_email = "MyEmAiL@GMail.com"
    @user.email = mixed_case_email
    @user.save
    @user.reload
    assert_equal mixed_case_email.downcase, @user.email
  end

  test "password should not be blank" do
    @user.password = @user.password_confirmation = "       "
    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return fals for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated user_entries should be deleted" do
    @user.save
    @user.user_entries.create!(distance: 100, time: 100, date: Time.zone.now)
    assert_difference 'UserEntry.count', -1 do
      @user.destroy
    end
  end

  test "right entries should be shown" do
    user = users(:michael)
    user.user_entries.each do |entry| 
      assert_equal user.id, entry.user_id
    end
  end

  test "entries should be shown latest to oldest" do
    user = users(:michael)
    prv = nil
    user.user_entries.each do |entry|
      if !prv.nil?
          assert entry.date <= prv
      end
      prv = entry.date
    end
  end

end
  
