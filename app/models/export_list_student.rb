class ExportListStudent < ActiveRecord::Base
	belongs_to :student
	belongs_to :export_list
	belongs_to :award
end
