require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    # Пустые поля / Empty fields
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                              email: "",
                              password: "",
                              password_confirmation: "" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Email can't be blank"
    assert_select 'li', "Email is invalid"
    assert_select 'li', "Password can't be blank"
    assert_select 'li', "Password is too short (minimum is 6 characters)"

    # Не верные данные / invalid information
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
    assert_select 'li', "Name can't be blank"
    assert_select 'li', "Email is invalid"
    assert_select 'li', "Password is too short (minimum is 6 characters)"
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                            email: "user@example.com",
                                            password: "password",
                                            password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert is_logged_in?
  end
  
end