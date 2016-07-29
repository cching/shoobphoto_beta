class AddColumnToOrderProf < ActiveRecord::Migration
  def change
  	add_column :orders, :shipping_first_name, :string
  	add_column :orders, :shipping_last_name, :string
  	add_column :orders, :address2, :string
  	add_column :orders, :shipping_address2, :string
  end
end
