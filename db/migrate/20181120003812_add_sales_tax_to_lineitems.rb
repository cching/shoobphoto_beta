class AddSalesTaxToLineitems < ActiveRecord::Migration
  def change
    add_column :lineitems, :sales_tax, :integer
  end
end
