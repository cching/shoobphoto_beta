class AddTeacherColToSchools < ActiveRecord::Migration
  def up
  	add_column :schools, :teacher, :boolean, :default => false
  end
end
