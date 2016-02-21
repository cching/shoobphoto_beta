class AddUserToYearbook < ActiveRecord::Migration
  def change
  	add_column :yearbooks, :user_id, :integer
  end
end
