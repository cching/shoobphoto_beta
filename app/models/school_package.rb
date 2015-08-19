class SchoolPackage < ActiveRecord::Base
	belongs_to :school
	belongs_to :package
end
