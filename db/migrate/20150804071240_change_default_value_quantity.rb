class ChangeDefaultValueQuantity < ActiveRecord::Migration
  def up
  	change_column :cart_items, :quantity, :integer, :default => 1
  end
end
