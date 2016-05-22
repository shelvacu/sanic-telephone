class CreateTables < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :url
    end

    create_table :users do |t|
      t.string :ip_address
      t.datetime :last_contact
      t.integer :room_id
      t.string :username
    end

    create_table :images do |t|
      t.string :image_data
      t.string :description
      t.integer :user_id
      t.integer :order
      t.integer :room_id
    end
  end
end
