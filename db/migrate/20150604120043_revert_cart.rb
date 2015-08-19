class RevertCart < ActiveRecord::Migration
  def up
	rename_column :order_packages, :cart_id, :student_id
  end
end
