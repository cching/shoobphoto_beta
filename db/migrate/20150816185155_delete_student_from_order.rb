class DeleteStudentFromOrder < ActiveRecord::Migration
  def change
  	remove_column :orders, :student_id
  end
end
