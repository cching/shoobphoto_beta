class AddBooleanToExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :correction, :boolean, default: false
  end
end
