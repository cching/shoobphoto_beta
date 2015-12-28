class AddColumnToContact < ActiveRecord::Migration
  def change
  	add_column :contacts, :jobseeker, :boolean
  end
end
