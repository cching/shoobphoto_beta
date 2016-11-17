class AddDownloadImageIdToOrderPackage1 < ActiveRecord::Migration
  def change
  	add_column :order_packages, :student_image_id, :integer
  end
end
