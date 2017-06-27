class ChangeStringToBoolean < ActiveRecord::Migration
  def change
  	remove_column :order_packages, :email_sent, :string
  	add_column :order_packages, :email_sent, :boolean
  end
end
