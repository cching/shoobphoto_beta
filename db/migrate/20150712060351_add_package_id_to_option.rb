class AddPackageIdToOption < ActiveRecord::Migration
  def up
  	remove_column :options, :package_type
  	add_column :options, :package_id, :integer
  end
end
