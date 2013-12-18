class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :address, :city, :project_name

  has_many :locations_users
  has_many :users, through: :locations_users
  has_many :reports
  has_many :photos, through: :reports
end
