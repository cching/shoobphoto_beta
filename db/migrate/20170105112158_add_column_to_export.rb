class AddColumnToExport < ActiveRecord::Migration
  def change
  	add_column :exports, :file_path_setup, :text
  end
end
