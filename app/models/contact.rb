class Contact < ActiveRecord::Base
  validates_presence_of :name, :address, :email, :city, :phone, :message

  validates_presence_of :student, :grade, :teacher_name, :if => :parent?
  validates_presence_of :school, :unless => :jobseeker?
  has_attached_file :file,
  	:url => ':s3_domain_url',
  	:path => '/images/contact/:id/:style/:filename'
	do_not_validate_attachment_file_type :file
end	
