class Job < ActiveRecord::Base
	has_many :packages
end
