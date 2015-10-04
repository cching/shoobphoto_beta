class AddShoobIdTostudents < ActiveRecord::Migration
  def up
  	add_column :students, :shoob_id, :string
  	add_column :students, :id_only, :boolean, :default => false
  end
end
