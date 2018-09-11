class AddBackgroundstoOrderPackages < ActiveRecord::Migration
  def change
    add_column :order_packages, :background, :string
  end
end
