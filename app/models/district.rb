class District < ActiveRecord::Base
	has_many :schools
	has_many :school_notes

	def dname
		return name
	end
end
