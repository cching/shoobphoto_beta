class RemoveColFromExtra < ActiveRecord::Migration
  def up
  	remove_column :extras, :price
  end
end
