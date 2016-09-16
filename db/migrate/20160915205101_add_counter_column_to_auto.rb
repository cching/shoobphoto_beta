class AddCounterColumnToAuto < ActiveRecord::Migration
  def change
  	add_column :autos, :failed_count, :integer
  	add_column :autos, :success_count, :integer
  end
end
