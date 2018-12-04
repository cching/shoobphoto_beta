class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :dproject_id

      t.timestamps
    end
  end
end
