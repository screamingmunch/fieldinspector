class LocationsController < ApplicationController
  skip_before_filter :logged_in?, only: [:new, :create]

  def index
    gon.current_user = current_user
  end

  def create
    gon.current_user = current_user
    @location = Location.where(params[:location]).first_or_create
    render json: @location.to_json
  end

  def location_json
    # x = {something => "test"}
    @locations = Location.all
    render :json => @locations
  end
end
