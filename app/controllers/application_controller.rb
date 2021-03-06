class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  # before_filter { gon.current_user = current_user }
  # this will make sure that current_user is gon.current_user
  # is available to each and every route

  private
  def current_user
    # binding.pry
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    unless @current_user
      flash[:notice] = "You must be logged in to perform that function."
      redirect_to log_in_path
    else
      return true
    end
  end

end
