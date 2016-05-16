class CreateWebcams < ActiveRecord::Migration
  def change
    create_table :webcams do |t|

      t.timestamps
    end
  end
end
