require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @comment = comments(:story)
    @post = posts(:orange)
  end

  #test "should redirect create when not logged in" do
  #  assert_no_difference 'Comment.count' do
  #    post post_path(@post), params: { post: { content: "Lorem ipsum", post_id: 1} }
  #  end
  #  assert_redirected_to login_url
  #end
  
  test "should redirect destroy when not logged in" do
    assert_no_difference 'Comment.count' do
      delete post_path(@comment)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong post" do
    log_in_as(users(:testuser))
    comment = comments(:tigers)
    assert_no_difference 'Comment.count' do
      delete post_path(comment)
    end
    assert_redirected_to root_url
  end

  test "should redirect destroy for wrong comment" do
    log_in_as(users(:testuser))
    comment = comments(:tigers)
    assert_no_difference 'Comment.count' do
      delete post_path(comment)
    end
    assert_redirected_to root_url
  end

end