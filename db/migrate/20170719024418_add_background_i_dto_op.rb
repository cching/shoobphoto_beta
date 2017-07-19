class AddBackgroundIDtoOp < ActiveRecord::Migration
  def change
  	add_column :order_packages, :background_id, :integer
  end
end
