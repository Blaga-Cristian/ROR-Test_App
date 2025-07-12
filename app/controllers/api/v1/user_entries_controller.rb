class Api::V1::UserEntriesController < ApplicationController
  
  before_action :authenticate_api_user!

  def index
    @entries = current_user_entries
    render json: @entries
  end

  def create
    @entry = current_user.user_entries.build(user_entry_params)
    if @entry.save
      render json: @entry, status: :created
    else
      render json: { errors: @entry.errors }, status: :unprocessable_entity
    end
  end

  private
    
    def user_entry_params
      params.require(:user_entry).permit(:time, :distance, :date)
    end
  
end
