class AddOptionIdToOrde < ActiveRecord::Migration
  def change
  	add_column :order_package_extras, :option_id, :integer
  end
end
