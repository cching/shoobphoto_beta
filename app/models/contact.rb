class Contact < ActiveRecord::Base
  validates_presence_of :name, :school, :address, :email, :city, :phone, :message

  validates_presence_of :student, :grade, :teacher_name, :if => :parent?

end
