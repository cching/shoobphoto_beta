class CreateExportDataStudents < ActiveRecord::Migration
  def change
    create_table :export_data_students do |t|
      t.integer :student_id
      t.integer :export_data_id

      t.timestamps
    end
  end
end
