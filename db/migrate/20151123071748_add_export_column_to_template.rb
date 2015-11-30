class AddExportColumnToTemplate < ActiveRecord::Migration
  def change
  	add_column :templates, :export_data_id, :integer
  	add_column :types, :preview, :boolean, default: :false
  end
end
