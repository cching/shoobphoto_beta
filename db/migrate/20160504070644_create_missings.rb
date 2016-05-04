class CreateMissings < ActiveRecord::Migration
  def change
    create_table :missings do |t|
      t.string :file_path

      t.timestamps
    end
  end
end
