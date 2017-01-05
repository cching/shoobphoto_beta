class AddHiddenToExportLIst < ActiveRecord::Migration
  def change
  	add_column :export_lists, :hidden, :boolean, default: false
  end
end
