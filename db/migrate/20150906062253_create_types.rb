class CreateTypes < ActiveRecord::Migration
  def change
    create_table :types do |t|
      t.string :name
      t.integer :pdf_id

      t.timestamps
    end
  end
end
