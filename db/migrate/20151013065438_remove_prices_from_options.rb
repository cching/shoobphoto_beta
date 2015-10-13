class RemovePricesFromOptions < ActiveRecord::Migration
  def change
  	remove_column :options, :price
  end
end
