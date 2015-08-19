class AddColumnToOrderPackagesStudent < ActiveRecord::Migration
  def up
  	add_column :order_packages, :student_id, :integer
  end
end
