class UsersController < ApplicationController
  before_action :logged_in_user,    only: [:index, :edit, :update, :destroy]
  before_action :correct_user,      only: [:edit, :update]
  before_action :admin_or_manager,  only: [:destroy]

  def show
    @user = User.find(params[:id])
    @entries = @user.user_entries.paginate(page: params[:page])
  end

  def index
    @users = get_users
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome!"
      redirect_to @user, status: :see_other
    else
      respond_to do |format|
        format.html { render 'new', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated successfully"
      redirect_to @user, status: :see_other
    else
      respond_to do |format|
        format.html { render 'edit', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash.now[:success] = "User deleted"

    @users = get_users

    respond_to do |format|
      format.html { redirect_to users_url, status: :see_other }
      format.turbo_stream
    end
  end

  private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url, status: :see_other) unless current_user?(@user)
    end
 
    def admin_or_manager
      unless (current_user.admin? || current_user.manager?)
        redirect_to root_url
      end
    end

    def get_users
      User.paginate(page: params[:page])
    end
    
end
