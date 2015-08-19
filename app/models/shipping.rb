class Shipping < ActiveRecord::Base
	belongs_to :school
	belongs_to :package
end
