class StaticPagesController < ApplicationController
  def home
    if logged_in? 
      @entries = current_user_entries
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
