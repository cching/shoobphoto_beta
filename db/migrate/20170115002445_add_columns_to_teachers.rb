class AddColumnsToTeachers < ActiveRecord::Migration
  def change
  	add_column :teachers, :full_name, :string
  	add_column :teachers, :teacher_id, :integer
  	add_column :teachers, :email, :string
  end
end
