class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

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
      session[:user_id] = Api::V1::AuthToken.decode(token)&.dig('user_id')
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user
    end

    def safe_format(user)
      { id: user.id,
        name: user.name,
        email: user.email,
        created_at: user.created_at,
        updated_at: user.updated_at,
        role: user.role,
        activated: user.activated }
    end

end
