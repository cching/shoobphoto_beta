class AddMustRecieveByDate < ActiveRecord::Migration
  def change
  	add_column :awards, :recieve_by, :date
  end
end
