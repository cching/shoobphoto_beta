class Banner < ActiveRecord::Base
	belongs_to :school_type

	has_attached_file :image,
  	:styles => { :medium => "300x300>", :thumb => "100x100>" },
  	:url => ':s3_domain_url',
  	:path => '/images/banners_front/:id/:style/:filename'
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
