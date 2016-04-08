class DownloadImage < ActiveRecord::Base
	belongs_to :student
	belongs_to :package
	has_many :order_packages

	has_attached_file :image,
    :url => ':s3_domain_url',
  	:path => '/images/:folder/:url.jpg',
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  end
