class Award < ActiveRecord::Base
	belongs_to :export_list
	has_many :user_students
	has_many :export_list_students
	belongs_to :school

	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/awards/:image_file_name'
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  	validates_presence_of :image
end
