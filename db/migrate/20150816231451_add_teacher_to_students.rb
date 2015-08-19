class AddTeacherToStudents < ActiveRecord::Migration
  def up
  	add_column :students, :teacher, :string
  end
end
