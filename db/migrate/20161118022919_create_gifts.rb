class CreateGifts < ActiveRecord::Migration
  def change
    create_table :gifts do |t|
      t.string :name
      t.text :description
      t.decimal :price

      t.timestamps
    end
  end
end
