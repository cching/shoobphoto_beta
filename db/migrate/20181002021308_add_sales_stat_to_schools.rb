class AddSalesStatToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :sales_stat, :string
  end
end
