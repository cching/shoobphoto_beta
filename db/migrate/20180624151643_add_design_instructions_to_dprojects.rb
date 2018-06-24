class AddDesignInstructionsToDprojects < ActiveRecord::Migration
  def change
  	add_column :dprojects, :design_instructions, :text
  end
end
