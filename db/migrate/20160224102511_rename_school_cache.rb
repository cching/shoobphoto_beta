class RenameSchoolCache < ActiveRecord::Migration
  def change
  	rename_column :schools, :student_ids, :student_cache
  	rename_column :schools, :yearbook_ids, :yearbook_cache
  end
end
