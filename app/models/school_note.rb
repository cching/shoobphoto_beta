class SchoolNote < ActiveRecord::Base
	belongs_to :district
	belongs_to :city
end
