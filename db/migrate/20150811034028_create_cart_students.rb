class CreateCartStudents < ActiveRecord::Migration
  def change
    create_table :cart_students do |t|
      t.integer :student_id
      t.integer :cart_id
    end

    remove_column :carts, :student_id
  end

end
