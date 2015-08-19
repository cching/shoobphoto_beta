class ChangePackageColumn < ActiveRecord::Migration
  def up
  	remove_column :packages, :package
  	add_column :packages, :package_id, :integer 
  end
end
