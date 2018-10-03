class AddSAddressToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :s_address, :string
  end
end
