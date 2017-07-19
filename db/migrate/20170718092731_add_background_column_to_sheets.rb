class AddBackgroundColumnToSheets < ActiveRecord::Migration
  def change
  	add_column :sheets, :background_id, :integer
  end
end
