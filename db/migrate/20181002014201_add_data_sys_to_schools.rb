class AddDataSysToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :data_sys, :string
  end
end
