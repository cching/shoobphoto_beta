class AddEmailCOlumnToCart < ActiveRecord::Migration
  def change
  	add_column :carts, :email, :string
  end
end
