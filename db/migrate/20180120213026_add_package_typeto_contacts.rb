class AddPackageTypetoContacts < ActiveRecord::Migration
  def change
  	add_column :contacts, :package_type, :string
  end
end
