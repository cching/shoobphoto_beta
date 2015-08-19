class CreateStudentImages < ActiveRecord::Migration
  def change
    create_table :student_images do |t|
      t.integer :package_id
      t.integer :student_id

      t.timestamps
    end
  end
end
