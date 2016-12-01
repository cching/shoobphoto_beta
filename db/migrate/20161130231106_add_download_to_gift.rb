class AddDownloadToGift < ActiveRecord::Migration
  def change
  	add_column :gifts, :download, :boolean, defualt: false
  end
end
