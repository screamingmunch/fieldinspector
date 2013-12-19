class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      session[:user_id] = @user.id #current_user needs the session[user_id] to be defined beforehand
      binding.pry
      gon.current_user = current_user.id
      redirect_to user_path(@user.id), :notice => "Signed up!"
    else
      render "new"
    end
  end

  def show
    gon.current_user = current_user
    @user = User.find(params[:id])
    @locations = @user.locations
  end

end
