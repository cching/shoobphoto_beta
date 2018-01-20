class AddOrderNumbertoContacts < ActiveRecord::Migration
  def change
  	add_column :contacts, :order_number, :integer
  end
end
