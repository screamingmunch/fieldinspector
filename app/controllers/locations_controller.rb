class LocationsController < ApplicationController

  def create
    @location = Location.where(params[:location]).first_or_create
    render json: @location.to_json
  end

  def location_json
    # x = {something => "test"}
    @locations = Location.all
    render :json => @locations
  end
end
