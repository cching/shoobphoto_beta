class Cart < ActiveRecord::Base
	has_many :cart_students, dependent: :destroy
	has_many :students, through: :cart_students
	
	has_many :order_packages, dependent: :destroy
	has_many :packages, through: :order_packages

	has_many :cart_items, dependent: :destroy
	has_many :items, through: :cart_items

	has_many :orders

	accepts_nested_attributes_for :order_packages, allow_destroy: true
	accepts_nested_attributes_for :cart_items, allow_destroy: true
	belongs_to :school
  	
	def to_param
  		cart_id
	end
end
