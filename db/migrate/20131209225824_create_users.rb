class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string   :first_name
      t.string   :last_name
      t.string   :email
      t.string   :password_hash
      t.string   :password_salt
      t.string   :profile_pic
      t.string   :company
      t.string   :title
      t.string   :role
      t.timestamps
    end
  end

end
