class ChangePriceCOlumn < ActiveRecord::Migration
  def up
  	change_column :options, :price, :decimal, :precision => 8, :scale => 2
  end
end
