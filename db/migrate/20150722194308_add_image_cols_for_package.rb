class AddImageColsForPackage < ActiveRecord::Migration
  def up
  	add_column :packages, :image_file_name, :string
  	add_column :packages, :image_content_type, :string
  	add_column :packages, :image_file_size, :integer
  end
end
