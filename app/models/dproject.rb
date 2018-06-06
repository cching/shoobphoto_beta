class Dproject < ActiveRecord::Base
	belongs_to :dschool, foreign_key: 'scode'
	belongs_to :school, foreign_key: 'scode'
end
