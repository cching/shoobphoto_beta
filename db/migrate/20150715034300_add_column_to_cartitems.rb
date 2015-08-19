class AddColumnToCartitems < ActiveRecord::Migration
  def up
  	add_column :cart_items, :pages, :integer
  end
end
