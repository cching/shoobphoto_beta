class ChangeNameoFteacherTable < ActiveRecord::Migration
  def change
  	rename_table :teachers, :educators
  	rename_column :students, :teacher_id, :educator_id
  end
end
