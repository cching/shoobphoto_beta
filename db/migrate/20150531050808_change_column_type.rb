class ChangeColumnType < ActiveRecord::Migration
	def change
    create_table :students do |t|
      t.integer :district_id
      t.string :student_id
      t.string :grad_id
      t.string :senior_id
      t.string :group_id
      t.string :last_name
      t.string :first_name
      t.integer :grade

    end
  end
 
end
