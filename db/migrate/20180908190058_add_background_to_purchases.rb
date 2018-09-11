class AddBackgroundToPurchases < ActiveRecord::Migration
  def change
    add_column :addons, :background, :string
  end
end
