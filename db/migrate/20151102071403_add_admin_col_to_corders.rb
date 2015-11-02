class AddAdminColToCorders < ActiveRecord::Migration
  def change
  	add_column :corders, :admin, :boolean
  	add_column :corders, :teacher, :boolean
  	add_column :corders, :parent, :boolean
  end
end
