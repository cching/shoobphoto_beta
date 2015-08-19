class AddHexColToCart < ActiveRecord::Migration
  def up
  	add_column :carts, :cart_id, :string
  	rename_column :order_packages, :student_id, :cart_id
  end
end
