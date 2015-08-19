class AddQuantityToExtras < ActiveRecord::Migration
  def change
  	add_column :extras, :quantity, :string
  end
end
