class CreateUserStudents < ActiveRecord::Migration
  def change
    create_table :user_students do |t|
      t.integer :user_id
      t.integer :student_id

      t.timestamps
    end
  end
end
