class ChangeScodeToString < ActiveRecord::Migration
  def change
  	change_column :schools, :scode, :string
  end
end
