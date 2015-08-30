class CreateExports < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.text :file_path

      t.timestamps
    end
  end
end
