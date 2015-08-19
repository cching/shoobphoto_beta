class AddOptionColumnToCart < ActiveRecord::Migration
  def up
  	add_column :carts, :purchased, :boolean, default: false
  end
end
