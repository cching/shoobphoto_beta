class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.string :name
      t.integer :price
      t.integer :print_id

      t.timestamps
    end
  end
end
