class UserEntriesController < ApplicationController
  before_action   :logged_in_user,  only: [:weekly_report, :create, :update, :destroy]
  before_action   :correct_data,    only: [:edit, :update, :destroy]
  
  def create
    @entry = current_user.user_entries.build(user_entry_params)
    if @entry.save
      flash.now[:success] = "Entry was created"
      respond_to do |format|
        format.html { redirect_to root_url, status: :see_other }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render 'static_pages/home', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    @entry.destroy
    flash.now[:success] = "Entry deleted"
    
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_url, status: :unprocessable_entity) }
      format.turbo_stream
    end
  end

  def edit
  end

  def update
    if @entry.update(user_entry_params)
      flash[:success] = "Entry updated"
      
      redirect_to root_url, status: :see_other
      #redirect_back(fallback_location: root_url, status: :see_other)
    else
      respond_to do |format|
        format.html { render 'user_entries/edit', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def weekly_report
    @weekly_stats = UserEntry.weekly_stats(current_user) 
  end

  private
    
    def user_entry_params
      params.require(:user_entry).permit(:time, :distance, :date)
    end

    def correct_data
      @entry = UserEntry.find_by(id: params[:id])
    
      if @entry.nil?
        redirect_to root_url, status: :see_other
        return
      end

      unless current_user.can_change?(@entry)
        redirect_to root_url, status: :see_other
        return
      end
    end

end
