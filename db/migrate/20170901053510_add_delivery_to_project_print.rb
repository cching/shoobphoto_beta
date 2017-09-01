class AddDeliveryToProjectPrint < ActiveRecord::Migration
  def change
  	add_column :project_prints, :delivery, :date
  	add_column :project_prints, :flexible, :boolean
  end
end
