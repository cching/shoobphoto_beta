class CreateCorders < ActiveRecord::Migration
  def change
    create_table :corders do |t|
      t.integer :cart_id
      t.string :ip_address
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :card_type
      t.string :card_expires_on
      t.decimal :price
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_zip
      t.string :shipping_state
      t.boolean :processed
      t.text :notes

      t.timestamps
    end
  end
end
