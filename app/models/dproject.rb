class Dproject < ActiveRecord::Base
	belongs_to :dschool, foreign_key: 'scode'
	belongs_to :school, foreign_key: 'scode'

	def previous_dproject
  		Dproject.where(["id < ?", id]).last
	end

	def next_dproject
  		Dproject.where(["id > ?", id]).first
	end
end
