class AddNameToPackages < ActiveRecord::Migration
  def up
  	add_column :packages, :name, :string
  end
end
