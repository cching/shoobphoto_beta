class CreateAccessCodeLogs < ActiveRecord::Migration
  def change
    create_table :access_code_logs do |t|
      t.string :access_code

      t.timestamps
    end
  end
end
