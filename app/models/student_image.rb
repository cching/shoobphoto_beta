class StudentImage < ActiveRecord::Base
	belongs_to :student
	belongs_to :package
end
