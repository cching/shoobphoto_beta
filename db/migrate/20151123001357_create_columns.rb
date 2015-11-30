class CreateColumns < ActiveRecord::Migration
  def change
    create_table :columns do |t|
      t.string :name

      t.timestamps
    end
    add_column :fields, :column_id, :integer
  end
end
