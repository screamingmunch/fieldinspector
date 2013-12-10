class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string   :image
      t.integer  :report_id
      t.integer  :user_id
      t.boolean  :image_processed
      t.timestamps
    end
  end
end
