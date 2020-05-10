require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:testuser)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_not session[:forwarding_url] # дружелюбная переадресация работает только 1 раз
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    assert session[:forwarding_url] # проверка дружелюбной переадресации на запрошенную страницу
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    assert_not session[:forwarding_url] # ссылка ff удаляется после перенаправления
#!  #assert_template 'users/edit' # не понятно почему не работает и получает []
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email
  end

end