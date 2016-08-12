class ExportList < ActiveRecord::Base
	belongs_to :user

	has_many :export_list_students
	has_many :students, through: :export_list_students
	belongs_to :school

	has_many :awards, dependent: :destroy
	accepts_nested_attributes_for :awards, allow_destroy: true
end
