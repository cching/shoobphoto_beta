class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :name
      t.integer :school_id

      t.timestamps
    end

    add_column :students, :period_id, :integer
  end
end
