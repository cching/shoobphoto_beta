class AddDefaultsToPackages < ActiveRecord::Migration
  def up
  	add_column :packages, :default_url, :string
  	add_column :packages, :default_folder, :string
  end
end
