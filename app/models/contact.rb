class Contact < ActiveRecord::Base
  validates_presence_of :name, :school, :address, :email, :city, :phone, :message

end
