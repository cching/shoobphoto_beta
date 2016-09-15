class AddINdexToStudentError < ActiveRecord::Migration
  def change
  	add_column :student_errors, :priority, :integer
  end
end
