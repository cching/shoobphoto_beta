class AddBackgroundToPurchasesUndo < ActiveRecord::Migration
  def change
    remove_column :addons, :background
  end
end
