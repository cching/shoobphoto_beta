class AddStudentIdColumnPackages < ActiveRecord::Migration
  def up
  	add_column :packages, :student_id, :integer
  end
end
