class Photo < ActiveRecord::Base
  attr_accessible :title, :report_id, :user_id, :image, :remote_image_url, :image_cache, :remove_image

  after_save :enqueue_image

  belongs_to :report

  mount_uploader :image, ImageUploader
  # validates :title, presence: true


  def image_name
    File.basename(image.path || image.filename) if image
  end

  def enqueue_image
    ImageWorker.perform_async(id, key) if key.present? && !image_processed?
  end

  class ImageWorker
    include Sidekiq::Worker

    def perform(id, key)
      # binding.remote_pry
      Rails.logger.debug
      photo = Photo.find(id)
      photo.key = key
      photo.remote_image_url = photo.image.direct_fog_url(with_path: true)
      photo.image.recreate_versions!(:thumb)
      photo.image_processed = true
      photo.save!
    end
  end

  def as_json(opts = {})
    super.merge(thumbnail_url: image.url(:thumb))
  end


end
