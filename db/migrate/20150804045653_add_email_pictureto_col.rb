class AddEmailPicturetoCol < ActiveRecord::Migration
  def up
  	add_column :options, :email_picture, :boolean, default: :false
  	add_column :order_packages, :email_picture, :boolean, default: :false
  end
end
