class Report < ActiveRecord::Base
  attr_accessible :title

  has_many :photos, dependent: :destroy
  belongs_to :user
end
