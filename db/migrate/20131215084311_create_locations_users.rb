class CreateLocationsUsers < ActiveRecord::Migration
  def change
    create_table :locations_users do |t|
      t.belongs_to  :location
      t.belongs_to  :user
      t.timestamps
    end
  end
end
