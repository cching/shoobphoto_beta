class PrintSize < ActiveRecord::Base
	belongs_to :print
	has_many :project_prints
end
