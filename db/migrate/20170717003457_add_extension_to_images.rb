class AddExtensionToImages < ActiveRecord::Migration
  def change
  	add_column :student_images, :extension, :string, :default => ".jpg"
  	add_column :senior_images, :extension, :string, :default => ".jpg"
  end
end
