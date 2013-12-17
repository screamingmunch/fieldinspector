class SessionsController < ApplicationController
  def new
    gon.current_user = current_user
    # redirect_to '/users/' + current_user.id.to_s if logged_in?
    # redirect_to '/home' unless request.user_agent =~ /Mobile|webOS/
  end

  def create
    # raise params.inspect
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user
      session[:user_id] = user.id
      redirect_to user_path(user.id), :notice => "Logged in!"
    else
      flash.now.alert = "Invalid email or password"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path :notice => "Logged out!"
  end
end
