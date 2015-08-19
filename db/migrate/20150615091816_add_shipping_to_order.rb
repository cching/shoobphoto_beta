class AddShippingToOrder < ActiveRecord::Migration
  def up
  	add_column :orders, :shipping_address, :text
  	add_column :orders, :shipping_city, :string
  	add_column :orders, :shipping_zip, :string
  	add_column :orders, :shipping_state, :string
  end
end
