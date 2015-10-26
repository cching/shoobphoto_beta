class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :school
      t.string :student
      t.string :grade
      t.string :teacher_name
      t.string :address
      t.string :city
      t.string :email
      t.string :phone
      t.text :message
      t.boolean :admin
      t.boolean :teacher
      t.boolean :parent

      t.timestamps
    end
  end
end
