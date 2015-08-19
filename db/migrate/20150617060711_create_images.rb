class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.text :url
      t.integer :item_id

      t.timestamps
    end
  end
end
