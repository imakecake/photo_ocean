require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:testuser)
  end

  test "post user interface" do
    log_in_as(@user) 
    get user_path(@user)
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    assert_select 'a[href=?]', "/users/#{@user.id}?page=2" # Есть ссылка на вторую страницу
    assert_select 'a', '2'
    # Недопустимая информация в форме.
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/posts?page=2' # Есть ссылка на вторую страницу ?page=2
    # Допустимая информация в форме.
    content = "This post really ties the room together"
    image = fixture_file_upload('test/fixtures/cat_1.jpeg', 'image/jpeg')  
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, image: image } }
    end
    assert assigns(:post).image.attached?
    assert_redirected_to user_path(@user)
    follow_redirect!  
    get user_path(@user)    
    assert_match content, response.body
    # Удаление сообщения.
    assert_select 'a', text: 'delete'
    first_post = @user.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Переход в профиль другого пользователя и попытка удаления его поста.
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end

  test "post root interface" do
    log_in_as(@user) 
    get root_path
    assert_select 'div.pagination'
    assert_select 'a[href=?]', '/?page=2' # Есть ссылка на вторую страницу
  end

  test "post sidebar count" do
    log_in_as(@user)
    get user_path(@user)#root_path
    assert_match @user.posts.count.to_s, response.body
    # У пользователя нет сообщений
    other_user = users(:mallory)
    log_in_as(other_user)
    #get user_path(other_user)#root_path
    #assert_match "0 posts", response.body
    other_user.posts.create!(content: "A post")
    get user_path(other_user)#root_path
    assert_match "Posts (1)", response.body
  end

  test "show post" do
    # Для всех пользователей, в том числе не зарегестрированных
    get user_path(@user)
    # Проверка ссылок на посты в профиле пользователя
    @user.posts.paginate(page: 1).each do |post|
      assert_select 'a[href=?]', "/posts/#{post.id}"
    end
    # Проверка страницы поста
    post = @user.posts.first
    get post_path(post)
    assert_match post.content, response.body
    # Попытка удаления поста кем угодно, кроме владельца
    assert_select 'a', text: 'delete', count: 0
    assert_no_difference 'Post.count' do
      delete post_path(post)
    end
    # Попытка удаления поста владельцем
    log_in_as(@user)
    get post_path(post)
    # Удаление сообщения со страницы поста с перенаправлением
    # на страницу пользователя
    assert_select 'a', text: 'delete'
    assert_difference 'Post.count', -1 do
      delete post_path(post)
    end
    assert_redirected_to user_path(@user)
  end

end