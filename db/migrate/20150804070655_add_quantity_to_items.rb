class AddQuantityToItems < ActiveRecord::Migration
  def up
  	add_column :cart_items, :quantity, :decimal
  end
end
