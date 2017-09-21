class AddTraitDefinitionToAward < ActiveRecord::Migration
  def change
  	add_column :awards, :trait_definition, :boolean
  	add_column :award_info_students, :trait, :string
  end
end
