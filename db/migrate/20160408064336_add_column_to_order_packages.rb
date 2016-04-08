class AddColumnToOrderPackages < ActiveRecord::Migration
  def change
  	add_column :order_packages, :download_image_id, :integer
  end
end
