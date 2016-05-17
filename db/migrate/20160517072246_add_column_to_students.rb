class AddColumnToStudents < ActiveRecord::Migration
  def change
  	add_column :students, :webcam, :boolean, default: false
  end
end
