class AddInvoiceIdToLineitems < ActiveRecord::Migration
  def change
    add_column :lineitems, :invoice_id, :integer
  end
end
