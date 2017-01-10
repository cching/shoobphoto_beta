class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.integer :school_id
      t.integer :scode
      t.string :name
      t.string :grade

      t.timestamps
    end
    add_column :students, :lower_teacher, :string
    add_column :students, :teacher_id, :integer
  end
end
