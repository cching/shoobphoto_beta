class StudentImage < ActiveRecord::Base
	belongs_to :student
	belongs_to :package

	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/:folder/:filename.jpg',
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/


  	has_attached_file :index, styles: {thumb: "28x35#"},
  	:url => ':s3_domain_url',
  	:path => "/images/:folder/:filename.jpg",
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
