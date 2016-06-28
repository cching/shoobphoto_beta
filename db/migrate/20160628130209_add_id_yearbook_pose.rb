class AddIdYearbookPose < ActiveRecord::Migration
  def change
  	add_column :order_packages, :senior_image_id, :integer
  end
end
