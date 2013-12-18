class LocationsUser < ActiveRecord::Base
  attr_accessible :location_id, :user_id
  belongs_to :location
  belongs_to :user

  validates_uniqueness_of :location_id, :scope => :user_id
end
