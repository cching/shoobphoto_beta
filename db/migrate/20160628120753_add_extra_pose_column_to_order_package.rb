class AddExtraPoseColumnToOrderPackage < ActiveRecord::Migration
  def change
  	add_column :order_packages, :extra_poses, :integer
  end
end
