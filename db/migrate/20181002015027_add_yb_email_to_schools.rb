class AddYbEmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :yb_email, :string
  end
end
