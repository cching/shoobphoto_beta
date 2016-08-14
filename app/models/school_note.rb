class SchoolNote < ActiveRecord::Base
	belongs_to :district
	belongs_to :city
	has_many :notes

	accepts_nested_attributes_for :notes, allow_destroy: true
end
  