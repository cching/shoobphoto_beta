class CreateCartTeams < ActiveRecord::Migration
  def change
    create_table :cart_teams do |t|
      t.integer :cart_id
      t.integer :team_id

      t.timestamps
    end
  end
end
