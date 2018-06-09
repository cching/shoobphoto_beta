class FixDeliveryColumnsToDprojects < ActiveRecord::Migration
  def change
  	rename_column :dprojects, :delivery_method, :delivery_type
  end
end
