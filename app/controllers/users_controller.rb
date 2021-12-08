class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  def index
    @users = User.paginate(page: params[:page], per_page: 15)
  end  

  def show 
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(page: params[:page], per_page: 10)
  end  

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save 
      log_in @user
      flash[:success] = "Добро пожаловать"
      redirect_to @user
    else
      render 'new'
    end    
  end 

  def edit 
    @user = User.find(params[:id])
  end 

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Профиль обновлен"
      redirect_to @user
    else
      render 'edit'
    end   
  end

  def destroy
    @user = User.find(params[:id]).destroy
    flash[:success] = "Пользователь удален"
    redirect_to users_url
  end  

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  # Подтверждает вход пользователя.
  def logged_in_user 
    unless logged_in?
      store_location
      redirect_to login_url
      flash[:danger] = "Сначала осуществите вход" 
    end   
  end

  # Подтверждает права пользователя.
  def correct_user
    @user = User.find(params[:id]) 
    redirect_to root_url unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin? 
  end  

end
