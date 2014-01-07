class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :address, :street, :city, :state, :zip, :project_name, :contractor_name, :contractor_address, :contractor_contact_person, :contractor_contact_phone, :risk_level

  has_many :locations_users
  has_many :users, through: :locations_users
  has_many :reports
  has_many :photos, through: :reports
end
