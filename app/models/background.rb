class Background < ActiveRecord::Base
	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/backgrounds/:filename',
                     :preserve_files => true
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

	belongs_to :sheets
	belongs_to :order_package
end
