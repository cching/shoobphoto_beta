class ChangeColTypeofassociaton < ActiveRecord::Migration
  def up
  	rename_column :order_packages, :student_id, :cart_id
  end
end
