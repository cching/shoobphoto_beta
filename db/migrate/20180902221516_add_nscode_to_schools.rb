class AddNscodeToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :Nscode, :string
  end
end
