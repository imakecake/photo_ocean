require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:testuser)
    @post = @user.posts.first
    @comment = @post.comments.build(content: "Lorem ipsum")
    @comment.user = @user
  end

  test "should be valid" do
    assert @comment.valid?
  end
    
  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "post id should be present" do
    @comment.post_id = nil
    assert_not @comment.valid?
  end

  test "content should be present " do
    @comment.content = " "
    assert_not @comment.valid?
  end

end
