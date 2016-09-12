class AddOrderIdTosearch1 < ActiveRecord::Migration
  def change
  	remove_column :searches, :order_id, :string
  	add_column :searches, :order_id, :integer
  end
end
