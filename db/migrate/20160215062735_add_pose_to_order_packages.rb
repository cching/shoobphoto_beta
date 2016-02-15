class AddPoseToOrderPackages < ActiveRecord::Migration
  def change
  	add_column :order_packages, :pose, :string
  end
end
