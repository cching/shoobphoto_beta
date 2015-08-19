class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
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
      t.date :card_expires_on
      t.decimal :price

      t.timestamps
    end
  end
end
