require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = "Photo Ocean"
    @user = users(:testuser)
  end

  # Не вошедший в систему пользователь

  test "not logged in user layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", signup_path
  end

  test "not logged in user should get sign up" do
    get signup_path
    assert_response :success
    assert_template 'users/new'
    assert_select "title", "Sign up | #{@base_title}"
    assert_select "a[href=?]", login_path, count: 2
  end

  test "not logged in user should get log in" do
    get login_path
    assert_response :success
    assert_template 'sessions/new'
    assert_select "title", "Log in | #{@base_title}"
    assert_select "a[href=?]", signup_path, count: 2
  end

  test "not logged in user should get users" do
    get users_path
    assert_response :success
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select "title", "All users | #{@base_title}"
    assert_select 'a', text: 'delete', count: 0
  end

=begin  
  test "not logged in user shouldn't get profile link" do
    assert_select 'a.dropdown', count: 0
  end

  test "not logged in user shouldn't get edit profile" do
    #assert_select 'a', text: 'Edit profile', count: 0
  end

  test "not logged in user shouldn't get log out" do
    
  end

  test "not logged in user shouldn't get account" do
    assert_select 'a', text: 'Account', count: 0
  end
=end
  # Вошедший в систему пользователь

  test "logged in user layout links" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 1
  end

  test "logged in user should get users" do
    log_in_as(@user)
    get users_path
    assert_response :success
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select "title", "All users | #{@base_title}"
  end
=begin  
  test "logged in user shouldn't get sign up" do
    log_in_as(@user)
    get signup_path
    assert_response :success
    assert_template 'users/new'
    assert_select "title", "Sign up | #{@base_title}"
  end

  test "logged in user shouldn't get log in" do
    log_in_as(@user)
    get login_path
    assert_response :success
    assert_template 'sessions/new'
    assert_select "title", "Log in | #{@base_title}"
  end

  test "logged in user should get profile link" do
    log_in_as(@user)
    assert_select "a", "Profile", count: 1
  end

  test "logged in user should get edit profile link" do
    log_in_as(@user)
    assert_select "a", "Edit profile", count: 1
  end

  test "logged in user should get log out" do
    log_in_as(@user)
    assert_select "a", "Log out", count: 1
  end
=end
end
