class OrderPackage < ActiveRecord::Base
	belongs_to :cart
	belongs_to :package
	belongs_to :option
	belongs_to :student
	has_many :order_package_extras, dependent: :destroy
	has_many :extras, through: :order_package_extras

	before_destroy :check_for_orders

	validates :package_id, uniqueness: {:scope => [:student_id, :cart_id]}


	accepts_nested_attributes_for :option
	accepts_nested_attributes_for :extras

	def self.image id
		op = OrderPackage.find(id)
		bucket = AWS::S3::Bucket.new('shoobphoto')

		if AWS::S3::S3Object.new(bucket, "images/#{op.folder}/#{op.url.upcase}.jpg").exists?
            s3object = AWS::S3::S3Object.new(bucket, "images/#{op.folder}/#{op.url.upcase}.jpg")
        else
            s3object = AWS::S3::S3Object.new(bucket, "images/#{op.folder}/#{op.url.downcase}.jpg")
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
