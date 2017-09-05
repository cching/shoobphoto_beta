class CreatePorders < ActiveRecord::Migration
  def change
    create_table :porders do |t|
      t.integer :project_id
      t.string :address
      t.string :city
      t.string :state
      t.string :zip_code
      t.string :card_type
      t.decimal :price
      t.string :shipping_address
      t.string :shipping_city
      t.string :shipping_zip
      t.string :shipping_state
      t.boolean :processed
      t.date :card_expires_on
      t.string :purchase_order
      t.boolean :free

      t.timestamps
    end
  end
end
