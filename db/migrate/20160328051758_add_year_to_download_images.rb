class AddYearToDownloadImages < ActiveRecord::Migration
  def change
  	add_column :download_images, :year, :string
  end
end
