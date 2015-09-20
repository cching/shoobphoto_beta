class AddSchoolToUsers < ActiveRecord::Migration
  def up
  	add_column :users, :school_id, :integer
  end
end
