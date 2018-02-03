class AddPhotoTypeToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :photo_type, :string
  end
end
