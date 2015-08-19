class Option < ActiveRecord::Base
	belongs_to :package
	has_many :image_types

	has_many :extra_assignments, dependent: :destroy
	has_many :extra_types, through: :extra_assignments

	has_many :order_packages, :dependent => :destroy

	accepts_nested_attributes_for :image_types, allow_destroy: true

	

end
