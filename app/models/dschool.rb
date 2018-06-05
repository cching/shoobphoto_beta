class Dschool < ActiveRecord::Base
	has_many :dprojects, foreign_key: 'scode'

	def name
		return name + "test"
	end
end


