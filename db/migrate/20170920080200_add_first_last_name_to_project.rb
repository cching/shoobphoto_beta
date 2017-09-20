class AddFirstLastNameToProject < ActiveRecord::Migration
  def change
  	add_column :projects, :first_name, :string
  	add_column :projects, :last_name, :string
  	remove_column :projects, :name, :string
  end
end
