class AddCurVendorToSChools < ActiveRecord::Migration
  def change
    add_column :schools, :cur_vendor, :string
  end
end
