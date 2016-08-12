class AddAwardIdToUserStudents < ActiveRecord::Migration
  def change
  	add_column :user_students, :award_id, :integer
  end
end
