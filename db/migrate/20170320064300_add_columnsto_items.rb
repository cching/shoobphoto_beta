class AddColumnstoItems < ActiveRecord::Migration
  def change
  	add_column :cart_items, :download, :boolean
  	add_column :cart_items, :product, :boolean
  	add_column :cart_items, :both, :boolean
  end
end
