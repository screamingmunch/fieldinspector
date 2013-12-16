class LocationsUsers < ActiveRecord::Base
  attr_accessible :loaction_id, :user_id

  belongs_to :location
  belongs_to :user
end
