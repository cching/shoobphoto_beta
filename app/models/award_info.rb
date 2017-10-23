class AwardInfo < ActiveRecord::Base
	belongs_to :award
	belongs_to :export_list
	has_many :award_info_students, dependent: :destroy
	has_many :students, through: :award_info_students
	validates :award_date, :receive_by, presence: true
	validates :time_period, presence: true, if: :award_add_period?
	validates :awarded_for, presence: true, if: :award_add_awarded_for?
	validates :definition, presence: true, if: :award_add_definition?

	def award_add_period?
		award.add_period?
	end

	def award_add_awarded_for?
		award.add_awarded_for?
	end

	def award_add_definition?
		award.add_definition?
	end

	def placeholder student_id
		students = award_info_students.where(:student_id => student_id)
		students.any? ? students.last.try(:trait) : ""
	end
end
