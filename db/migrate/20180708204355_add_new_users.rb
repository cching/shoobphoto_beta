class AddNewUsers < ActiveRecord::Migration
  def change
  	add_column :users, :developer, :boolean
  	add_column :users, :photographer, :boolean
  	add_column :users, :employee, :boolean
  end
end
