class CreateExtras < ActiveRecord::Migration
  def change
    create_table :extras do |t|
      t.string :name
      t.integer :extra_type_id

      t.timestamps
    end
  end
end
