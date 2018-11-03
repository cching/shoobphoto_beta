class CreateAfiles < ActiveRecord::Migration
  def change
    create_table :afiles do |t|
      t.integer :attachment_id

      t.timestamps
    end
  end
end
