class ChangeColumnTypeCsChoolnotes < ActiveRecord::Migration
  def change
  	remove_column :school_notes, :cdscode
  	add_column :school_notes, :cdscode, :string
  end
end
