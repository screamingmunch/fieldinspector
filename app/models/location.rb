class Location < ActiveRecord::Base
  attr_accessible :latitude, :longitude, :address, :city
end
