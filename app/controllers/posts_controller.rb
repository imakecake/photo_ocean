class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @post = current_user.posts.build
    @feed_items = current_user.posts.paginate(page: params[:page])
  end

  def new
    @post = current_user.posts.build()
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = "Post created!"
      redirect_to current_user
    else
      @feed_items = current_user.posts.paginate(page: params[:page])
      render 'posts/index'
    end
  end

  def show
    @post = Post.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to current_user
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to request.referrer || current_user || root_url
  end

  private

    def post_params
      params.require(:post).permit(:content, :image)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

end
