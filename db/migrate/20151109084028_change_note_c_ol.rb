class ChangeNoteCOl < ActiveRecord::Migration
  def change
  	rename_column :notes, :school_id, :school_note_id
  end
end
