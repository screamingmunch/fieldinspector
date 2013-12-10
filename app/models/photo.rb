class Photo < ActiveRecord::Base
  attr_accessible :report_id, :user_id, :image
  belongs_to :report

  mount_uploader :image, ImageUploader


end
