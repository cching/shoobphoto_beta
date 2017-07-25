class AddColumnToBackgrounds < ActiveRecord::Migration
  def change
  	add_column :backgrounds, :hidden, :boolean, default: false
  end
end
