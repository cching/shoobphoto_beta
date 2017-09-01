class CreatePrintStyles < ActiveRecord::Migration
  def change
    create_table :print_styles do |t|
      t.string :style
      t.integer :price
      t.integer :print_id

      t.timestamps
    end
  end
end
