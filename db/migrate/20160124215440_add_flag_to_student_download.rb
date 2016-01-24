class AddFlagToStudentDownload < ActiveRecord::Migration
  def change
  	add_column :student_images, :downloaded, :boolean, default: :false
  end
end
