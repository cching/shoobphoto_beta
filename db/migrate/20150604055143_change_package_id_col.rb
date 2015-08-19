class ChangePackageIdCol < ActiveRecord::Migration
  def up
  	rename_column :packages, :package_id, :option_id
  end
end
