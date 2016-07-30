class AddAccessCodeToStudents < ActiveRecord::Migration
  def change
  	add_column :students, :access_code, :string
  end
end
