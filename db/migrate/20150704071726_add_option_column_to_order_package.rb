class AddOptionColumnToOrderPackage < ActiveRecord::Migration
  def up
  	add_column :order_packages, :option_id, :integer
  end
end
