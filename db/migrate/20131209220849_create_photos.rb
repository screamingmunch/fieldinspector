
class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string   :image
      t.integer  :report_id
      t.string   :remote_image_url
      t.boolean  :image_processed
      t.timestamps
    end
  end
end
