class Report < ActiveRecord::Base
  attr_accessible :report_date, :description, :location_id, :user_id, :report_type

  has_many :photos, dependent: :destroy
  belongs_to :location
  belongs_to :user
end

