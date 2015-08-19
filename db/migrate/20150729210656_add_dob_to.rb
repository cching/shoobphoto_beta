class AddDobTo < ActiveRecord::Migration
  def up
  	add_column :students, :dob, :date
  end
end
