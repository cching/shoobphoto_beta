class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.decimal :price
      t.integer :school_id, :null => true
      t.date :begin
      t.date :end
      t.integer :option_id, :null => true
      t.integer :extra_id, :null => true
      t.integer :package_id, :null => true

      t.timestamps
    end
  end
end
 