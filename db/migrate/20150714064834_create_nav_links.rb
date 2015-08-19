class CreateNavLinks < ActiveRecord::Migration
  def change
    create_table :nav_links do |t|
      t.string :title
      t.string :slug
      t.integer :lft
      t.integer :rgt
      t.integer :parent_id
      t.integer :position

      t.timestamps
    end
  end
end
