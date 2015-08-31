class ChangeDatetype < ActiveRecord::Migration
  def up
  	remove_column :corders, :card_expires_on
  	add_column :corders, :card_expires_on, :date
  end
end
