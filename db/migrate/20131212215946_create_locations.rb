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
      t.string   :risk_level
      t.string   :contractor_name
      t.string   :contractor_address
      t.string   :contractor_contact_person
      t.string   :contractor_contact_phone
      t.timestamps
    end
  end
end
