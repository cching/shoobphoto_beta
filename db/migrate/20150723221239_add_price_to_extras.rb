class AddPriceToExtras < ActiveRecord::Migration
  def up
  	add_column :extras, :price, :decimal
  end
end
