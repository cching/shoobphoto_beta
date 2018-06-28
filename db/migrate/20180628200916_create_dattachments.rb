class CreateDattachments < ActiveRecord::Migration
  def change
    create_table :dattachments do |t|
      t.integer :dproject_id
      t.text :notes

      t.timestamps
    end
  end
end
