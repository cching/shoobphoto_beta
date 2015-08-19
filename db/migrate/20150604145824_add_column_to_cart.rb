class AddColumnToCart < ActiveRecord::Migration
  def up
  	add_column :carts, :price, :decimal
  end
end
