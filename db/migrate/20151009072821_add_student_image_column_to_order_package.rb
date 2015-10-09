class AddStudentImageColumnToOrderPackage < ActiveRecord::Migration
  def up
  	add_column :order_packages, :url, :string
  end
end
