class AddProcessedToOrders < ActiveRecord::Migration
  def up
  	add_column :orders, :processed, :boolean, default: false
  end
end
