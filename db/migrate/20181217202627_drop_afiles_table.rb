class DropAfilesTable < ActiveRecord::Migration
  def change
    drop_table :afiles
  end
end
