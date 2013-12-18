class LocationsController < ApplicationController
  skip_before_filter :logged_in?, only: [:new, :create]

  def index
    # gon.current_user = current_user
  end

  def new
    @location = Location.new
  end

  def create
    gon.current_user = current_user
    # @location = Location.where(params[:location]).first_or_create
    binding.pry

    if Location.find_by_address(params[:location][:address])
      puts '*'*20
      puts "it exists!"
      @location = Location.find_by_address(params[:location][:address])
    else
      puts '*'*20
      puts "go create it sucker"
      @location = Location.create(params[:location])

      # @location = Location.where(params[:location]).create
    end
    # if Location.where(params[:location][:address])
    #   @location = Location.where(params[:location][:address]).first
    # else
    #   @location = Location.where(params[:location]).create
    # end
    unless @location.users.include?(current_user)
      @location.users << current_user
    end
    render json: @location
  end

  def show
    # gon.current_user = current_user
    @location = Location.find(params[:id])
    @users = @location.users
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    location = Location.find(params[:id])
    location.update_attributes(params[:location])
    redirect_to location_path
  end

  def destroy
    @location = Location.find(params[:id])
    # binding.pry
    if @location.users.include?(current_user) && @location.users.length == 1
      @location = Location.delete(params[:id])
    else
      @location.users.find(current_user.id)
      LocationsUser.find_by_location_id_and_user_id(@location.id, current_user.id).delete
    end
    redirect_to "/users/#{current_user.id}"
  end

  def location_json
    # x = {something => "test"}
    @locations = Location.all
    render :json => @locations
  end
end
