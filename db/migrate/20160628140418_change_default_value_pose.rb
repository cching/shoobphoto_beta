class ChangeDefaultValuePose < ActiveRecord::Migration
  def change
  change_column :order_packages, :extra_poses, :integer, :default => 0


  end
end
