class Item < ActiveRecord::Base
	has_many :cart_items, dependent: :destroy
	has_many :carts, through: :cart_items

	has_many :images

  belongs_to :subcategory

  has_many :searchterm_items
  has_many :searchterms, through: :searchterm_items

	has_attached_file :main,
  	:url => ':s3_domain_url',
  	:path => '/images/main/:filename.jpg',
                     :preserve_files => true
  	validates_attachment_content_type :main, :content_type => /\Aimage\/.*\Z/

    has_attached_file :pdf,
    :url => ':s3_domain_url',
    :path => '/images/pdf/images/main/:filename',
                     :preserve_files => true
    validates_attachment_content_type :pdf, :content_type => /\Apdf\/.*\Z/

  	has_attached_file :thumb,
  	:url => ':s3_domain_url',
  	:path => '/images/thumbs/:filename.jpg',
                     :preserve_files => true
  	validates_attachment_content_type :thumb, :content_type => /\Aimage\/.*\Z/
end
 