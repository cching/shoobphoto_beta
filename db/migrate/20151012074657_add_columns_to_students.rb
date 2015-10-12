class AddColumnsToStudents < ActiveRecord::Migration
  def up
  	add_column :students, :data1, :string
  	add_column :students, :data2, :string
  	add_column :students, :data3, :string
  	add_column :students, :data4, :string
  end
end
