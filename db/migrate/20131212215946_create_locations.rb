class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.float    :latitude
      t.float    :longitude
      t.string   :address
      t.string   :street
      t.string   :city
      t.string   :state
      t.string   :project_name
      t.integer  :zip
      t.timestamps
    end
  end
end
