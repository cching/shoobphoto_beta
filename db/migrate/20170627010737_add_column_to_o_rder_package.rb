class AddColumnToORderPackage < ActiveRecord::Migration
  def change
  	add_column :order_packages, :email_sent, :string
  end
end
