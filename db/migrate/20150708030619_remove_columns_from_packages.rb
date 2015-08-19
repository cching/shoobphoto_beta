class RemoveColumnsFromPackages < ActiveRecord::Migration
  def up
  	remove_column :packages, :option_id
  	remove_column :packages, :package_type
  end
end
