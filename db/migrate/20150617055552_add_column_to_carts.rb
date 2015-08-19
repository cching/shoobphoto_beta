class AddColumnToCarts < ActiveRecord::Migration
  def up
  	add_column :carts, :cart_type, :string
  end
end
