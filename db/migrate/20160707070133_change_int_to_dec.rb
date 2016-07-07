class ChangeIntToDec < ActiveRecord::Migration
  def change
  	change_column :addons, :price_with, :decimal
  	change_column :addons, :price_without, :decimal
  end
end
