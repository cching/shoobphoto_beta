class AddPermanentToField < ActiveRecord::Migration
  def change
  	add_column :fields, :permanent, :string
  end
end
