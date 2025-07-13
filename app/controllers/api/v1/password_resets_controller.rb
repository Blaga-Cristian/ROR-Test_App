class Api::V1::PasswordResetsController < ApplicationController
  before_action :get_user,          only: [:update]
  before_action :valid_user,        only: [:update]
  before_action :check_expiration,  only: [:update]

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      head :no_content
    else
      render json: { error: "Email address not found" }, status: :not_found
    end
  end

#  def update
#    if user_params[:password].empty? 
#      @user.errors.add(:password, "can't be empty")
#      render json: { errors: @user.errors }, status: :unprocessable_entity
#    elsif @user.update(user_params)
#      render json: safe_format(@user), status: :ok
#    else
#      render json: { error: 'Could not reset password' }, status: :unprocessable_entity
#    end
#  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        redirect_to root_url, status: :see_other
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url, status: :see_other
      end
    end


end
