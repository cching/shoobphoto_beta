class AwardInfoStudent < ActiveRecord::Base
	belongs_to :student
	belongs_to :award_info
end
