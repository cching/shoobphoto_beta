class CreateExportLists < ActiveRecord::Migration
  def change
    create_table :export_lists do |t|
      t.integer :user_id
      t.boolean :submitted

      t.timestamps
    end
  end
end
