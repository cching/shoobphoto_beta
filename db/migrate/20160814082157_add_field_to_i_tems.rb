class AddFieldToITems < ActiveRecord::Migration
  def change
  	add_column :items, :size, :string
  	add_column :items, :product_type, :string
  end
end
