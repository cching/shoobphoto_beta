class CreateTemplateColumns < ActiveRecord::Migration
  def change
    create_table :template_columns do |t|
      t.integer :column_id
      t.integer :template_id

      t.timestamps
    end
  end
end
