class AddInvoiceDropdown < ActiveRecord::Migration
  def change
    add_column :dprojects, :invoice_status, :string
  end
end
