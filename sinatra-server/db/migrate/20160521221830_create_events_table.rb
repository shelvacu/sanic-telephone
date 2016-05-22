class CreateEventsTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :data
      t.integer :user_id
    end
  end
end
