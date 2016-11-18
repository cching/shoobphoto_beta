class Gift < ActiveRecord::Base
	has_attached_file :image,
  	:url => ':s3_domain_url',
  	:path => '/images/gift_images/:filename.jpg',
                     :preserve_files => true
  	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

    has_many :order_package_gifts
    has_many :gifts, through: :order_package_gifts

  	Quantity = [
    ['1', 1],
    ['2', 2],
    ['3', 3],
    ['4', 4],
    ['5', 5],
    ['6', 6],
    ['7', 7],
    ['8', 8],
    ['9', 9],
    ['10', 10]
  ]
end
 