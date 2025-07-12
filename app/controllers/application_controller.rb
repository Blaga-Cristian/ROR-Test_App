class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    def authenticate_api_user!
      token = request.headers['Authorization']&.split(' ')&.last
      session[:user_id] = User.find_by(authentication_token: token).id
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
    end
end
