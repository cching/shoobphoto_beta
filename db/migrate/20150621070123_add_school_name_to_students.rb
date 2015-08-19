class AddSchoolNameToStudents < ActiveRecord::Migration
  def up
  	add_column :students, :school, :string
  end
end
