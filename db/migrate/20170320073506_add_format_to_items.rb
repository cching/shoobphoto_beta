class AddFormatToItems < ActiveRecord::Migration
  def change
  	add_column :items, :format, :string
  end
end
