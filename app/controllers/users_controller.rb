class UsersController < ApplicationController
  before_action :logged_in_user, only:[:edit, :update, :password, :updatePassword]
  before_action :set_user, only:[:show, :edit, :update, :password, :updatePassword]

  def new
    @user = User.new
  end
  
  def show
    if validPage? == false
      render "errors/not_found"
    end
    
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    if logged_in? == false # precondition
      redirect_to login_path
    elsif isMyPage == false # allow user to edit own data.
      flash[:danger] = "Access denied :  #{request.url}. => redirect to your page."
      redirect_to edit_user_path(current_user)
    end
  end
  
  def update
    if @user.update(user_params)
      flash[:info] = "プロフィールを編集しました."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def password
    if isMyPage == false
      flash[:danger] = "Access denied :  #{request.url}. => redirect to your page."
      redirect_to chg_pwd_path(current_user)
    end
  end
  
  def updatePassword
    if @user.update(user_params)
      flash[:info] = "プロフィールを編集しました."
      redirect_to @user
    else
      render 'password'
    end
  end

private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :place)
  end
  
  def set_user
    @user = User.find_by_id(params[:id])
  end
  
  def isMyPage
    # check user id is available.
    if validPage? == false
      return false
    end
    
    # check target user id.
    if current_user.id == @user.id
      return true
    else
      return false
    end
  end
  
  def validPage?
    !@user.nil?
  end
  
end
