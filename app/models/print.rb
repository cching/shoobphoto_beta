class Print < ActiveRecord::Base
	has_many :project_prints
	has_many :projects, through: :project_prints
	has_many :sizes
	has_many :print_styles, dependent: :destroy

	has_many :print_sizes, dependent: :destroy

	accepts_nested_attributes_for :print_sizes, allow_destroy: true
	accepts_nested_attributes_for :print_styles, allow_destroy: true

	validates :name, :price, :presence => true

	def description
		price > 0 ? "$#{price} #{price_description}" : "Free"
	end
end
