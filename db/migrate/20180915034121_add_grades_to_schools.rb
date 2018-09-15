class AddGradesToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :grades, :string
  end
end
