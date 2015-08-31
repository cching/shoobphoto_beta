class Item < ActiveRecord::Base
	has_many :cart_items, dependent: :destroy
	has_many :carts, through: :cart_items

	has_many :images

	has_attached_file :main,
  	:url => ':s3_domain_url',
  	:path => '/images/main/:filename.jpg'
  	validates_attachment_content_type :main, :content_type => /\Aimage\/.*\Z/

  	has_attached_file :thumb,
  	:url => ':s3_domain_url',
  	:path => '/images/thumbs/:filename.jpg'
  	validates_attachment_content_type :thumb, :content_type => /\Aimage\/.*\Z/
end
