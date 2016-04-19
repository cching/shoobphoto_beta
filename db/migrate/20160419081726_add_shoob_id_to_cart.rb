class AddShoobIdToCart < ActiveRecord::Migration
  def change
  	add_column :carts, :shoob_id, :string
  end
end
