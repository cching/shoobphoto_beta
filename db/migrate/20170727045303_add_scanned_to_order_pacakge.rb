class AddScannedToOrderPacakge < ActiveRecord::Migration
  def change
  	add_column :order_packages, :scanned, :boolean, default: false
  end
end
