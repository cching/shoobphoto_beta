class AddTitlesToProjects < ActiveRecord::Migration
  def change
    add_column :dprojects, :title, :string
  end
end
