class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :school_id
      t.integer :jtype_id
      t.string :job
      t.date :jdate
      t.string :location

      t.timestamps
    end
  end
end
