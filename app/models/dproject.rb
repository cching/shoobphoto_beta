class Dproject < ActiveRecord::Base
	belongs_to :dschool, foreign_key: 'scode'
end
