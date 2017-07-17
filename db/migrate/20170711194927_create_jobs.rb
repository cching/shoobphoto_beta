class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.integer :scode
      t.string :account
      t.date :date
      t.string :job
      t.string :jobtype
      t.integer :package_id

      t.timestamps
    end
  end
end
