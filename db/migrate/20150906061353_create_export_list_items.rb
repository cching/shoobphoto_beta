class CreateExportListItems < ActiveRecord::Migration
  def change
    create_table :export_list_items do |t|
      t.integer :user_id
      t.integer :student_id

      t.timestamps
    end
  end
end
