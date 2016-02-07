class AddColumnToYearbooks < ActiveRecord::Migration
  def change
  	add_column :yearbooks, :sold_by, :string
  end
end
