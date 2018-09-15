class AddCategoryToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :category, :string
  end
end
