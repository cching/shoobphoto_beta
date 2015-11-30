class AddColumnUrl1ToStudentImages < ActiveRecord::Migration
  def change
  	add_column :student_images, :url1, :string
  end
end
