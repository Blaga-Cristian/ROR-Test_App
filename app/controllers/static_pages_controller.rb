class StaticPagesController < ApplicationController
  def home
    if logged_in? 
      @entries = current_user_entries
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
