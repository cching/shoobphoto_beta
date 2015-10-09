class AddColumnsToOrderPackage < ActiveRecord::Migration
  def up
  	add_column :packages, :multiple, :boolean, :default => false
  	add_column :student_images, :url2, :string
  	add_column :student_images, :url3, :string
  	add_column :student_images, :url4, :string
  end
end
