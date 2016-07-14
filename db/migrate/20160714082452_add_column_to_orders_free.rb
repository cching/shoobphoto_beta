class AddColumnToOrdersFree < ActiveRecord::Migration
  def change
  	add_column :orders, :free, :boolean, default: false
  end
end
