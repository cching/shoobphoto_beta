class CreateImageTypes < ActiveRecord::Migration
  def change
    create_table :image_types do |t|
      t.string :name
      t.string :option_id

      t.timestamps
    end
  end
end
