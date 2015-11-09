class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :school_id
      t.text :note
      t.text :action
      t.boolean :complete

      t.timestamps
    end
  end
end
