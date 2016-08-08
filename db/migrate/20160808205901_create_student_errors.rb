class CreateStudentErrors < ActiveRecord::Migration
  def change
    create_table :student_errors do |t|
      t.integer :auto_id
      t.text :error_text
      t.string :error_description

      t.timestamps
    end
  end
end
