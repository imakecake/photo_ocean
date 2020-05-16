require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:testuser)
    @non_admin = users(:archer)
    @bot = users(:robot)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    #num_of_pages %= @users.count#User.where(activated: true).count
    #num_of_pages.times do |p|
    #3.upto(5) do |p|
    first_page_of_users = User.where(activated: true).paginate(page: 1) # 2
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',
                                                  method: :delete
      end
    end
    assert_difference "User.count", -1 do
      delete user_path(@non_admin)
    end
  #end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    assert_select 'a', text: 'delete', count: 0
  end

  test "user_path for not activated user should redirect to root_url" do
    get users_path
    get user_path(@bot)
    assert_response :redirect
    follow_redirect!
    assert_template 'static_pages/home'
  end

  test "index shouldn't show not activated users yet" do
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    page_of_users = User.where(activated: true).paginate(page: 1)
    page_of_users.each do |user|
      assert_not_equal user_path(user), user_path(@bot) 
    end
  end

end