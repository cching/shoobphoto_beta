class ExportList < ActiveRecord::Base
	belongs_to :user

	has_many :export_list_students
	has_many :students, through: :export_list_students
	belongs_to :school
end
