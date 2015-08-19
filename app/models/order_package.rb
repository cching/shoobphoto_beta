class OrderPackage < ActiveRecord::Base
	belongs_to :cart
	belongs_to :package
	belongs_to :option
	belongs_to :student
	has_many :order_package_extras, dependent: :destroy
	has_many :extras, through: :order_package_extras

	accepts_nested_attributes_for :option
	accepts_nested_attributes_for :extras
end
