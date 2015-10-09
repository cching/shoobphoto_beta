class OrderPackage < ActiveRecord::Base
	belongs_to :cart
	belongs_to :package
	belongs_to :option
	belongs_to :student
	has_many :order_package_extras, dependent: :destroy
	has_many :extras, through: :order_package_extras

	accepts_nested_attributes_for :option
	accepts_nested_attributes_for :extras

	def self.image url
		bucket = AWS::S3::Bucket.new('shoobphoto')
		s3object = AWS::S3::S3Object.new(bucket, "images/#{url}.jpg") #do default image in col later

        return s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
	end
end
