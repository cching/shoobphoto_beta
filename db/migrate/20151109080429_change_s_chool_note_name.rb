class ChangeSChoolNoteName < ActiveRecord::Migration
  def change
  	rename_column :school_notes, :principle, :principal
  end
end
