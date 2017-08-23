class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :school
      t.string :email
      t.string :name
      t.string :position
      t.string :phone
      t.date :delivery
      t.boolean :flexible

      t.timestamps
    end
  end
end
