class AddColumnToAddons < ActiveRecord::Migration
  def change
  	add_column :addon_sheets, :background_id, :integer
  end
end
