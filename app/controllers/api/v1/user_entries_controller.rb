class Api::V1::UserEntriesController < ApplicationController
  
  before_action :authenticate_api_user!
  before_action :set_entry,         only: [:show, :update, :destroy]
  before_action :correct_data,      only: [:update, :destroy]

  def index
    @entries = UserEntry.all
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

  def my_entries
    @entries = current_user.user_entries
    render json: @entries, status: :ok
  end

  def weekly_report
    stats = UserEntry.weekly_stats(current_user)
    stats.transform_keys! do |first_day_of_week|
      "#{first_day_of_week.strftime('%d-%m-%Y')} - #{first_day_of_week.end_of_week.strftime('%d-%m-%Y')}"
    end
    render json: stats, status: :ok
  end

  def show
    render json: @entry, status: :ok
  end

  def update
    if @entry.update(user_entry_params)
      render json: @entry, status: :ok
    else
      render json: { errors: @entry.errors }, status: :unprocessable_entity
    end
  end


  def destroy
    @entry.destroy
    head :no_content
  end

  private
    
    def user_entry_params
      params.require(:user_entry).permit(:time, :distance, :date)
    end

    def set_entry
      @entry = UserEntry.find_by(id: params[:id])
      return render json: { error: 'Not found' }, status: :not_found unless @entry
    end

    def correct_data 
      unless current_user.can_change?(@entry)
        return render json: { error: 'Unauthorized' }, status: :forbidden
      end
    end
  
end
