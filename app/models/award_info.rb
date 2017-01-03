class AwardInfo < ActiveRecord::Base
	belongs_to :award
	belongs_to :export_list
	has_many :award_info_students, dependent: :destroy
	has_many :students, through: :award_info_students
end
