class AddColumnToCOrders < ActiveRecord::Migration
  def change
  	add_column :corders, :schools, :string
  end
end
