class CreateAwardInfoStudents < ActiveRecord::Migration
  def change
    create_table :award_info_students do |t|
      t.integer :student_id
      t.integer :award_info_id

    end
  end
end
