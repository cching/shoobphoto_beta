class AddNoteToLab < ActiveRecord::Migration
  def change
  	add_column :dprojects, :note_to_lab, :text
  end
end
