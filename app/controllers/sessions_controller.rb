class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user&.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? 
          remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated" 
        message += "\nCheck your email for the activation link"
        flash[:warning] = message
        redirect_to root_url, status: :see_other
      end
    else
      flash.now[:danger] = "Invalid mail/password combination"
      respond_to do |format|
        format.html { render 'new', status: :unprocessable_entity }
        format.turbo_stream
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url(format: :html), status: :see_other   
  end
  
end
