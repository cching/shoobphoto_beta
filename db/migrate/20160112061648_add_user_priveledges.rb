class AddUserPriveledges < ActiveRecord::Migration
  def change
  	add_column :users, :school_admin, :boolean, default: false
  	add_column :users, :principal, :boolean, default: false
  	add_column :users, :teacher, :boolean, default: false
  	add_column :users, :secretary, :boolean, default: false
  	add_column :users, :parent, :boolean, default: false

  end
end
