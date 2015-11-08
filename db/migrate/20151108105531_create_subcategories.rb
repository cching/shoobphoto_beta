class CreateSubcategories < ActiveRecord::Migration
  def change
    create_table :subcategories do |t|
      t.integer :category_id
      t.string :name

      t.timestamps
    end
    add_column :items, :subcategory_id, :integer
  end
end
