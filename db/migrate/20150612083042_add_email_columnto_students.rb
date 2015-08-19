class AddEmailColumntoStudents < ActiveRecord::Migration
  def up
  	add_column :students, :email, :string
  	change_column :students, :grade, :string
  end
end
