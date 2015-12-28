class AddColumnStoExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :title, :string
  	add_column :export_lists, :name, :string
  	add_column :export_lists, :date, :date
  	add_column :export_lists, :delivery, :date
  	add_column :export_lists, :data, :text

  end
end
