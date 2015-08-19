class AddBooleanToCart < ActiveRecord::Migration
  def up
  	add_column :carts, :processed, :boolean, default: false
  end
end
