class CreateStudents < ActiveRecord::Migration
   def up
    change_column :students, :grade, :string
  end
end
