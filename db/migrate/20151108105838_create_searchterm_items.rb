class CreateSearchtermItems < ActiveRecord::Migration
  def change
    create_table :searchterm_items do |t|
      t.integer :item_id
      t.integer :searchterm_id

      t.timestamps
    end
  end
end
