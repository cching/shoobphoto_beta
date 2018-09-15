class AddEnrollmentToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :enrollment, :string
  end
end
