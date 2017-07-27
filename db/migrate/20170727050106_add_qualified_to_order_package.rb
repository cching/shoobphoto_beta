class AddQualifiedToOrderPackage < ActiveRecord::Migration
  def change
  	add_column :order_packages, :qualified, :boolean, default: false
  end
end
