class AddInvoicesToDprojects < ActiveRecord::Migration
  def change
  	remove_column :dprojects, :invoicing
  	remove_column :dprojects, :invoice_quantity
  	remove_column :dprojects, :invoice_price
  	add_column :dprojects, :invoice_date, :datetime
  	add_column :dprojects, :invoice_addressee, :string
  	add_column :dprojects, :invoice_description, :text
  	add_column :dprojects, :invoice_subtotal, :decimal
  	add_column :dprojects, :invoice_credit, :decimal
  	add_column :dprojects, :invoice_shipping, :decimal
  	add_column :dprojects, :invoice_sales_tax, :decimal
  	add_column :dprojects, :invoice_total, :decimal
  	add_column :dprojects, :invoice_paid, :decimal
  	add_column :dprojects, :invoice_payment_date, :datetime
  	add_column :dprojects, :invoice_notes, :text
  end
end
