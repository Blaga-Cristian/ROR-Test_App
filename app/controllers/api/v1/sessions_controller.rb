class Api::V1::SessionsController < ApplicationController
  
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password]) && user&.activated?
      token = Api::V1::AuthToken.encode(user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end
  
end
