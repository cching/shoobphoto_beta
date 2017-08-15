class AddEnrolledFlagToSchool < ActiveRecord::Migration
  def change
  	add_column :schools, :enrolled, :boolean, default: false
  end
end
