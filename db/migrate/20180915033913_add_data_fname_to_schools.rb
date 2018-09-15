class AddDataFnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :data_fname, :string
  end
end
