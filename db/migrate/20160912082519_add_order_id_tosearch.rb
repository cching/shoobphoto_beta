class AddOrderIdTosearch < ActiveRecord::Migration
  def change
  	add_column :searches, :order_id, :string
  end
end
