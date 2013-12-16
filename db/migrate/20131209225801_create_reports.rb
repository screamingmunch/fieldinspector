class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer  :location_id
      t.integer  :user_id
      t.date     :report_date
      t.string   :report_type
      t.text     :description
      t.timestamps
    end
  end
end
