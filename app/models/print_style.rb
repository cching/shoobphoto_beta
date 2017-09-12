class PrintStyle < ActiveRecord::Base
	belongs_to :print
	has_many :project_prints
end
