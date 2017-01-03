class ExportList < ActiveRecord::Base
	belongs_to :user

	has_many :export_list_students
	has_many :students, through: :export_list_students
	belongs_to :school

	has_many :award_infos
	accepts_nested_attributes_for :award_infos, allow_destroy: true

	has_many :awards, dependent: :destroy
	accepts_nested_attributes_for :awards, allow_destroy: true,
    :reject_if => proc { |a| a['title'].blank? || a['abbreviation'].blank? }
end
 