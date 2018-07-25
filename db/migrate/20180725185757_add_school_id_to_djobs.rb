class AddSchoolIdToDjobs < ActiveRecord::Migration
  def change
  	add_column :djobs, :school_id, :integer
  end
end
