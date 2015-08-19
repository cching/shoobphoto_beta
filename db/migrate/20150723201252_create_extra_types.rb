class CreateExtraTypes < ActiveRecord::Migration
  def change
    create_table :extra_types do |t|
      t.string :name
      t.boolean :required
      t.boolean :multiple

      t.timestamps
    end
  end
end
