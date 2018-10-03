class AddDataEmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :data_email, :string
  end
end
