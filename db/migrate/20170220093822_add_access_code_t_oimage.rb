class AddAccessCodeTOimage < ActiveRecord::Migration
  def change
  	add_column :student_images, :access_code, :string
  end
end
