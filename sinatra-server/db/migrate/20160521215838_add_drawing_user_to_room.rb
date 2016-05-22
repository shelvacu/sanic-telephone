class AddDrawingUserToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :drawing_user_id, :integer
  end
end
