class AddPrinEmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :prin_email, :string
  end
end
