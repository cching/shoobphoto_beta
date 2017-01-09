class AddDateColumnToAwardInfo < ActiveRecord::Migration
  def change
  	add_column :export_lists, :submit_date, :date
  end
end
