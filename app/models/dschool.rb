class Dschool < ActiveRecord::Base
	has_many :dprojects, foreign_key: 'scode'

	def dname
		return name
	end
end


