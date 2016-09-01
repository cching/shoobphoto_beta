class AddColumnToStudentImage < ActiveRecord::Migration
  def change
  	add_column :student_images, :shoob_id, :string
  end
end
