class AddEnrolledToStudent < ActiveRecord::Migration
  def change
  	add_column :students, :enrolled, :boolean, default: false
  end
end
