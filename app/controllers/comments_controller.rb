class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def index
    @post = Post.find(params[:id])
    @comments = @post.comments.paginate(page: params[:page])
    rescue ActiveRecord::RecordNotFound
      redirect_to request.referrer || current_user
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    @comment.image.attach(params[:comment][:image])
    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to post_path(@post)
    else
      @items = @post.comments.paginate(page: params[:page])
      render 'comments/index'
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to request.referrer || post_path(@post) || root_url
  end

  private
    
    def comment_params
      params.require(:comment).permit(:content, :image)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end

end