class Changenoticesdatatype < ActiveRecord::Migration
  def change

#This changes the column from timestamp to string
change_column :djobs, :NOTICES, :string


  end
end
