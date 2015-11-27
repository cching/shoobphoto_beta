class AddTemplateColumnToExport < ActiveRecord::Migration
  def change
  	add_column :export_data, :template_id, :integer
  end
end
