class CreateExtraAssignments < ActiveRecord::Migration
  def change
    create_table :extra_assignments do |t|
      t.integer :option_id
      t.integer :extra_type_id

      t.timestamps
    end
  end
end
