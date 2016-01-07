class AddMoreColumnsToYearbooks < ActiveRecord::Migration
  def change
  	add_column :yearbooks, :notes, :text
  	add_column :yearbooks, :payment_type, :string
  end
end
