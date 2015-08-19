class RemoveImageIdColsFromStudents < ActiveRecord::Migration
  def up
  	remove_column :students, :grad_id
  	remove_column :students, :senior_id
  	remove_column :students, :group_id
  end
end
