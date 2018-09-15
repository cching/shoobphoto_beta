class AddMAddressToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :m_address, :string
  end
end
