class AddSec1EmailToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :sec1_email, :string
  end
end
