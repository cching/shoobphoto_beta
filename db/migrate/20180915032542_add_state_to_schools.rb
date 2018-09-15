class AddStateToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :state, :string
  end
end
