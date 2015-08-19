class AddColumnsToPackaes < ActiveRecord::Migration
  def up
  	add_column :packages, :folder, :string
  	remove_column :student_images, :folder
  end
end
