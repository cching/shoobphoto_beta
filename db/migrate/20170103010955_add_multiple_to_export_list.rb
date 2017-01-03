class AddMultipleToExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :multiple, :boolean, default: false
  end
end
