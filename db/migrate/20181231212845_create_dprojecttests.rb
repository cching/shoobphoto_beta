class CreateDprojecttests < ActiveRecord::Migration
  def change
    create_table :dprojecttests do |t|
      t.integer :dproject_id
      t.string :comments

      t.timestamps
    end
  end
end
