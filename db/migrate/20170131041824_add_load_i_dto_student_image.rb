class AddLoadIDtoStudentImage < ActiveRecord::Migration
  def change
  	add_column :student_images, :load_id, :string
  end
end
