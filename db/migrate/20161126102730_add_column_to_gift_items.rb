class AddColumnToGiftItems < ActiveRecord::Migration
  def change
  	add_column :gifts, :number, :string
  end
end
