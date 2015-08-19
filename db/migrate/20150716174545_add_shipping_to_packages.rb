class AddShippingToPackages < ActiveRecord::Migration
  def up
  	add_column :packages, :shipping, :decimal
  end
end
