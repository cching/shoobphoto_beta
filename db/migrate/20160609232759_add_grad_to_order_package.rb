class AddGradToOrderPackage < ActiveRecord::Migration
  def change
  	add_column :order_packages, :grad, :string
  end
end
