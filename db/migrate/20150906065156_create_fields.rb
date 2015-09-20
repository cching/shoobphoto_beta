class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :x
      t.integer :y
      t.integer :width
      t.integer :height
      t.string :align
      t.string :column
      t.integer :template_id
      t.string :font
      t.integer :font_id
      t.integer :text_size
      t.string :color
      t.integer :spacing
      t.string :name

      t.timestamps
    end
  end
end
