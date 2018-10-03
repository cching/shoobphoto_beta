class AddNcountyToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :ncounty, :string
  end
end
