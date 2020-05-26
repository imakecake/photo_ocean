class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def new
    redirect_to root_url and return if logged_in?
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page])
    @post = current_user.posts.build if logged_in?
    redirect_to root_url and return unless @user.activated?
    rescue ActiveRecord::RecordNotFound
      redirect_to request.referrer || current_user || root_url
  end

  def create
    @user = User.new(user_params)
    @user.avatar.attach(params[:avatar])
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.avatar.attach(params[:avatar])
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User successfully deleted"
    redirect_to users_url
    # Добавить возможность вариативности редиректа либо на home, либо на users
    # в зависимости от того, кто удаляет страницу: сам пользователь или админ
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
    end

    # Предварительные фильтры

    # Подтверждает права пользователя
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
      rescue ActiveRecord::RecordNotFound
        redirect_to request.referrer || current_user || root_url
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
