class CreateDprojects < ActiveRecord::Migration
  def change
    create_table :dprojects do |t|
      t.integer :id
      t.string :scode
      t.datetime :completed_at
      t.text :description

      t.timestamps
    end
    add_index :dprojects, :id, unique: true
  end
end
