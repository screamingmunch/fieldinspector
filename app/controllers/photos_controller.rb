class PhotosController < ApplicationController
  def index
    @photos = Photo.all || "photos"
    @uploader = Photo.new.image_source
    @uploader.success_action_redirect = new_report_photo_url
  end

  def new
    @photo = Photo.new(params[:photos])
    @photo[:report_id] = params[:report_id]
    # @photo[:user_id] = current_user.id
    # render :inline => report_id
  end

  def create
    @photo = Photo.create(params.slice :image)
    # render json: @photo
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
    redirect_to photos_path, notice: "Photo was successfully destroyed!"
  end

  def all_photos
    @photos = Photo.all
    respond_to do |format|
      format.html
      format.json { render json: @photos }
    end
  end

end
