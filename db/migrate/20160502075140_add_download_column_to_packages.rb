class AddDownloadColumnToPackages < ActiveRecord::Migration
  def change
  	add_column :options, :download, :boolean
  end
end
