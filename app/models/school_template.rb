class SchoolTemplate < ActiveRecord::Base
	belongs_to :school
	belongs_to :type
end
