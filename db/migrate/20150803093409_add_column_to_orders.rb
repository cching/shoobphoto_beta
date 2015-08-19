class AddColumnToOrders < ActiveRecord::Migration
  def up
  	add_column :orders, :posted, :boolean, :default => false
  end
end
