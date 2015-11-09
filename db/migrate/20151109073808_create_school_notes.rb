class CreateSchoolNotes < ActiveRecord::Migration
  def change
    create_table :school_notes do |t|
      t.integer :cdscode
      t.string :name
      t.integer :district_id
      t.integer :city_id
      t.string :address
      t.string :phone
      t.string :principle
      t.string :secretary

      t.timestamps
    end
  end
end
