class RemoveSchoolColFromStudents < ActiveRecord::Migration
  def up
  	remove_column :students, :school
  end
end
