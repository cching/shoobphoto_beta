class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.text :name
      t.decimal :price
      t.string :item_id
      t.boolean :per_page

      t.timestamps
    end
  end
end
