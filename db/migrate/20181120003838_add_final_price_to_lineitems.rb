class AddFinalPriceToLineitems < ActiveRecord::Migration
  def change
    add_column :lineitems, :final_price, :integer
  end
end
