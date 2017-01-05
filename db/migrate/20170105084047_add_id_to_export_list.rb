class AddIdToExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :export_list_id, :integer
  end
end
