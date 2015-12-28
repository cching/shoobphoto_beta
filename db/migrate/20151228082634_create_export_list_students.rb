class CreateExportListStudents < ActiveRecord::Migration
  def change
    create_table :export_list_students do |t|
      t.integer :student_id
      t.integer :export_list_id

      t.timestamps
    end
  end
end
