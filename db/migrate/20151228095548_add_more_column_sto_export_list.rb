class AddMoreColumnStoExportList < ActiveRecord::Migration
  def change
  	add_column :export_lists, :school, :string
  end
end
