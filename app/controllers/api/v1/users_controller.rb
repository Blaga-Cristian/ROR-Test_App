class Api::V1::UsersController < ApplicationController
  before_action :authenticate_api_user!,    except: [:create]
  before_action :set_user,                  only: [:show, :update, :destroy]
  before_action :can_update,                only: [:update]
  before_action :can_destroy,               only: [:destroy]

  def index
    @users = User.all.to_a

    @users.map! { |user| safe_format(user) }

    render json: @users, status: :ok
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      render json: safe_format(@user), status: :ok
    else
      render json: { error: 'Cannot create user' }, status: :unprocessable_entity
    end
  end

  def show
    if @user
      render json: safe_format(@user), status: :ok
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def update
    if @user.update(user_params)
      render json: safe_format(@user), status: :ok
    else 
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end
  
  def destroy
    @user.destroy
    head :no_content
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(id: params[:id])
    end
    
    def can_update
      return render json: { error: 'Not allowed' }, status: :forbidden unless 
      current_user == @user || current_user.admin? || current_user.manager?
    end

    def can_destroy
      return render json: { error: 'Not allowed' }, status: :forbidden unless
      current_user != @user && (current_user.admin? || current_user.manager?)
    end

end
