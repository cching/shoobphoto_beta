class RemoveColsFromSchoolPackage < ActiveRecord::Migration
  def up
  	remove_column :school_packages, :id
  	remove_column :school_packages, :created_at
  	remove_column :school_packages, :updated_at
  end
end
