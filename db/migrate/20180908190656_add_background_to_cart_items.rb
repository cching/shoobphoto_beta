class AddBackgroundToCartItems < ActiveRecord::Migration
  def change
    add_column :cart_items, :background, :string
  end
end
