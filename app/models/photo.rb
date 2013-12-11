class Photo < ActiveRecord::Base
  attr_accessible :title, :report_id, :user_id, :image
  belongs_to :report

  mount_uploader :image, ImageUploader
  validates :title, presence: true


end
