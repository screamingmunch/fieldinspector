class PhotosController < ApplicationController
  skip_before_action :logged_in?, only: [:new, :create, :destroy]

  def index
    @photos = Photo.all || "photos"
    @uploader = Photo.new.image
    @uploader.success_action_redirect = new_photo_url
  end

  def new
    @photo = Photo.new(key: params[:key])
    # @photo[:report_id] = params[:report_id]
    # @photo[:user_id] = current_user.id
    # render :inline => report_id
  end

  def create
    # @photo = Photo.create(params.slice :image)
    # render json: @photo
    @photo = Photo.create(params[:photo])
    redirect_to root_path
  end

  def show
    @photo = Photo.find(params[:id])
    # @photo.remote_image_url ? response = {remote_image_url: @photo.image_source.url(:thumb).to_s} : response = {remote_image_url: false}
    respond_to do |format|
      format.html
      format.json { render json: @photo.to_json }
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to photos_path, notice: "Photo #{@photo.title} was successfully destroyed!"
  end

  def all_photos
    @photos = Photo.all
    respond_to do |format|
      format.html
      format.json { render json: @photos }
    end
  end


  #strong parameters (Rails 4)
# private
#   def photo_params
#     params.require(:photo).permit(:title, :user_id, :caption, :image, :remote_image_url)
#   end

#   def key_params
#     params.require(:photo).permit(:key)
#   end

end
