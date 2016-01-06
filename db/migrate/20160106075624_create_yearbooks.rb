class CreateYearbooks < ActiveRecord::Migration
  def change
    create_table :yearbooks do |t|
      t.date :date
      t.integer :quantity
      t.decimal :amount
      t.integer :student_id

      t.timestamps
    end
  end
end
