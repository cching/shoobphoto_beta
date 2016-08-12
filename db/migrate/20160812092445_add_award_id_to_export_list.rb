class AddAwardIdToExportList < ActiveRecord::Migration
  def change
  	add_column :export_list_students, :award_id, :integer
  end
end
