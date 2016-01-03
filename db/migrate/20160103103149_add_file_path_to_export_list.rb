class AddFilePathToExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :file_path, :text
  end
end
