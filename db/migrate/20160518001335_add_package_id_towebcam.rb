class AddPackageIdTowebcam < ActiveRecord::Migration
  def change
  	add_column :headshot_photos, :package_id, :integer
  end
end
