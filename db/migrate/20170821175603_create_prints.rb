class CreatePrints < ActiveRecord::Migration
  def change
    create_table :prints do |t|
     	t.string :name
     	t.integer :price
     	t.string :price_description
      t.timestamps
    end
  end
end
