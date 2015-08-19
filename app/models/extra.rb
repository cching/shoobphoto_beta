class Extra < ActiveRecord::Base
	belongs_to :extra_type

	has_many :prices

	has_many :order_package_extras, dependent: :destroy
	has_many :order_packages, through: :order_package_extras
	has_attached_file :image,
  	:styles => { :medium => "300x300>", :thumb => "100x100>" },
  	:url => ':s3_domain_url',
  	:path => '/images/options/:id/:style/:filename'
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
