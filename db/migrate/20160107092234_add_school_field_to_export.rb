class AddSchoolFieldToExport < ActiveRecord::Migration
  def change
  	add_column :export_lists, :school_id, :integer
  end
end
