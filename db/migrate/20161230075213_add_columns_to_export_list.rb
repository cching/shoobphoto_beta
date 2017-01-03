class AddColumnsToExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :award_id, :integer
  end
end
