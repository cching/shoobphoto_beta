class AddClearTeachersToSchools < ActiveRecord::Migration
  def change
  	add_column :schools, :clear_teachers, :boolean
  end
end
