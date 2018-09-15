class AddAwdEmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :awd_email, :string
  end
end
