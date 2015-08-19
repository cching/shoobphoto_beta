class AddFolderToStudentImage < ActiveRecord::Migration
  def up
  	add_column :student_images, :folder, :string
  end
end
