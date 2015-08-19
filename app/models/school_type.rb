class SchoolType < ActiveRecord::Base
	has_many :schools
	has_many :banners
end
