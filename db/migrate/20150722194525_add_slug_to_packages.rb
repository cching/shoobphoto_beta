class AddSlugToPackages < ActiveRecord::Migration
  def up
  	add_column :packages, :slug, :string
  end
end
