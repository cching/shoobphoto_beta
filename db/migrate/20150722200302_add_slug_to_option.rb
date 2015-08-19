class AddSlugToOption < ActiveRecord::Migration
  def up
  	add_column :options, :slug, :string
  end
end
