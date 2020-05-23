require 'test_helper'
class UsersProfileTest < ActionDispatch::IntegrationTest
  
  include ApplicationHelper
  
  def setup
    @user = users(:testuser)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.avatar'
    assert_match @user.posts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.posts.paginate(page: 1).each do |post|
      assert_match post.content, response.body
    end
    assert_match @user.following.count.to_s, response.body
    assert_select 'a[href=?]', following_user_path(@user)
    assert_match @user.followers.count.to_s, response.body
    assert_select 'a[href=?]', followers_user_path(@user)
  end

end