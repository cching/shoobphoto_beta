class RemoveColumnsFromItems < ActiveRecord::Migration
  def up
  	add_column :items, :number, :string
  end
end
