class RemoveItemId < ActiveRecord::Migration
  def up
  	remove_column :items, :item_id
  end
end
