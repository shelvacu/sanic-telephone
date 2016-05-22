class ChangeEventsDataToText < ActiveRecord::Migration
  def up
    change_column :events, :data, :text
  end
end
