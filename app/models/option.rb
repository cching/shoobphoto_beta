class Option < ActiveRecord::Base
	belongs_to :package
	has_many :image_types

	has_many :extra_assignments, dependent: :destroy
	has_many :extra_types, through: :extra_assignments

	has_many :option_carts, dependent: :destroy
	has_many :order_packages, through: :option_carts

	accepts_nested_attributes_for :image_types, allow_destroy: true

	has_many :prices

	accepts_nested_attributes_for :prices, allow_destroy: true

	def price school = nil
    prices.where('school_id = ? OR school_id IS NULL', school).where('enddate > ? OR enddate IS NULL', Time.now).order('school_id DESC, enddate DESC, begin DESC').first.price rescue 0
  	end

end
