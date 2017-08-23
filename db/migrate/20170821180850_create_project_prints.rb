class CreateProjectPrints < ActiveRecord::Migration
  def change
    create_table :project_prints do |t|
      t.integer :project_id
      t.integer :print_id
      t.integer :quantity
      t.text :description

      t.timestamps
    end
  end
end
