class AddIndexToCartStudent < ActiveRecord::Migration
  def change
  	add_column :cart_students, :i, :integer
  end
end
