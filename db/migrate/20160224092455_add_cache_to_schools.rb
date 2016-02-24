class AddCacheToSchools < ActiveRecord::Migration
  def change
  	add_column :schools, :student_ids, :text
  end
end
