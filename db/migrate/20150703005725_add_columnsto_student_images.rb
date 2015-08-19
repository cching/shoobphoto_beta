class AddColumnstoStudentImages < ActiveRecord::Migration
  def up
  	add_column :student_images, :url, :text
  	add_column :student_images, :grade, :string
  end
end
