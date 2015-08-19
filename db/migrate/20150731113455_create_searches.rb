class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :student_first_name
      t.string :student_last_name
      t.string :first_name
      t.string :last_name
      t.string :school_id
      t.string :phone
      t.string :email
      t.string :address
      t.string :card_type
      t.string :state
      t.string :zip
      t.string :billing_address
      t.string :billing_zip
      t.string :city
      t.string :billing_city
      t.boolean :processed

      t.timestamps
    end
  end
end
