class CreateAddons < ActiveRecord::Migration
  def change
    create_table :addons do |t|
      t.string :name
      t.integer :price_with
      t.integer :price_without
      t.boolean :popup
      t.integer :image_count

      t.timestamps
    end
  end
end
