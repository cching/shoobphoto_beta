class AddQuantityToOrderPackage < ActiveRecord::Migration
  def change
  	add_column :order_packages, :quantity, :integer
  end
end
