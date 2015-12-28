class ChangeColummType < ActiveRecord::Migration
  def change
  	remove_column :export_lists, :data
  	add_column :export_lists, :data, :string
  end
end
