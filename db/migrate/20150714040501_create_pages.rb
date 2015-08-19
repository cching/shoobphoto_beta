class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :title
      t.text :body
      t.string :slug
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true
      t.integer :parent_id, :null => true, :index => true

      t.timestamps
    end
  end
end
