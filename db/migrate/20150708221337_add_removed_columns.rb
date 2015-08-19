class AddRemovedColumns < ActiveRecord::Migration
  def up
  	remove_column :packages, :folder, :string
  	add_column :student_images, :folder, :string
  end
end
