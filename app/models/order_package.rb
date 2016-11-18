class OrderPackage < ActiveRecord::Base
	belongs_to :cart
	belongs_to :package
	belongs_to :student
	has_many :order_package_extras, dependent: :destroy
	has_many :extras, through: :order_package_extras
	has_many :option_carts, dependent: :destroy
	has_many :options, through: :option_carts
	belongs_to :download_image
	belongs_to :student_image
	has_many :favorites
	has_many :sheets
	has_many :addon_sheets

	has_many :order_package_gifts
    has_many :gifts, through: :order_package_gifts

	before_destroy :check_for_orders


	accepts_nested_attributes_for :extras

	def self.image id
		op = OrderPackage.find(id)
		bucket = AWS::S3::Bucket.new('shoobphoto')
		image = StudentImage.where(:student_id => op.student_id).where(:package_id => op.package.id).last

		if AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{op.url.upcase}.jpg").exists?
            s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{op.url.upcase}.jpg")
        else
            s3object = AWS::S3::S3Object.new(bucket, "images/#{image.folder}/#{op.url.downcase}.jpg")
        end

        return s3object.url_for(:read, :expires => 60.minutes, :use_ssl => true)
	end
 
	private
	  def check_for_orders
	    if cart.purchased?
	      return false
	    end
	  end
end
