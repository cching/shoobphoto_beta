class Contact < ActiveRecord::Base
  validates_presence_of :name, :address, :email, :city, :phone, :message

  validates_presence_of :student, :grade, :teacher_name, :if => :parent?
  validates_presence_of :school, :unless => :jobseeker?

end	
