class DeleteColPackages < ActiveRecord::Migration
  def up
  	remove_column :packages, :student_id
  end
end
