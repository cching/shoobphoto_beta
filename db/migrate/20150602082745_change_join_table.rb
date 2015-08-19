class ChangeJoinTable < ActiveRecord::Migration
  def up
  	remove_column :order_packages, :order_id
  	add_column :order_packages, :student_id, :integer
  end
end
