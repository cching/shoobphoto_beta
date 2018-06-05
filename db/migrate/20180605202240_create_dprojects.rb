class CreateDprojects < ActiveRecord::Migration
  def change
    create_table :dprojects do |t|
      t.string :scode
      t.datetime :completed_at
      t.text :description

      t.timestamps
    end
  end
end
