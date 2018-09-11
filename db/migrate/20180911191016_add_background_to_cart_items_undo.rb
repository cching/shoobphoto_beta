class AddBackgroundToCartItemsUndo < ActiveRecord::Migration
  def change
    remove_column :cart_items, :background
  end
end
