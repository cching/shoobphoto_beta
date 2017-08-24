class CreatePrintSizes < ActiveRecord::Migration
  def change
    create_table :print_sizes do |t|
      t.string :size
      t.integer :price
      t.integer :print_id

      t.timestamps
    end
  end
end
