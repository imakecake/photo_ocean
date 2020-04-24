require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "Photo Ocean"
  end

  test "should get new" do
    get users_new_path
    assert_response :success
    assert_select "title", "Sign up | #{@base_title}"
  end



end
