class CorDerFreeBoolean < ActiveRecord::Migration
  def change
  	add_column :corders, :free, :boolean
  end
end
