require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    patch user_path(@user), params: { user: {
        name: @user.name,
        email: @user.email,
        password: "foo",
        password_confirmation: "bar" } }
    assert_response :unprocessable_entity
  end

  test "successful edit" do  
    log_in_as(@user)
    get edit_user_path(@user)
    name = "Eample Name"
    email = "example@gmail.com"
    patch user_path(@user), params: { user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: "" } }
    
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

 
 test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: {
        name: name,
        email: email,
        password: "",
        password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to  @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end


  test "should redirect user when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url

    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
    
    patch user_path(@user), params: { user: {
      name: @user.name,
      email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

end
