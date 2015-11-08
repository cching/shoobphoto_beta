class CreateSearchterms < ActiveRecord::Migration
  def change
    create_table :searchterms do |t|
      t.string :name

      t.timestamps
    end
  end
end
