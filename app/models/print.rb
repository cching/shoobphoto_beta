class Print < ActiveRecord::Base
	has_many :project_prints
	has_many :projects, through: :project_prints

	has_many :print_sizes, dependent: :destroy

	accepts_nested_attributes_for :print_sizes, allow_destroy: true

	validates :name, :price, :presence => true
end
