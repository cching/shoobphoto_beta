class AddAwdFnameToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :awd_fname, :string
  end
end
