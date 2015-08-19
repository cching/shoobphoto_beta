class CreateStudentProofs < ActiveRecord::Migration
  def change
    create_table :student_proofs do |t|
      t.integer :package_id
      t.integer :student_id
      t.string :url
      t.string :grade
      t.string :folder

      t.timestamps
    end
  end
end
