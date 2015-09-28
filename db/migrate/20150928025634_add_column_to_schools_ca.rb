class AddColumnToSchoolsCa < ActiveRecord::Migration
  def up
  	add_column :schools, :ca_code, :string
  end
end
