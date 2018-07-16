class TempInvoiceChanges < ActiveRecord::Migration
  def change
  	add_column :dprojects, :invoice_bool, :boolean
  end
end
