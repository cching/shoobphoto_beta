class ExportDataStudent < ActiveRecord::Base
	belongs_to :student
	belongs_to :export_data
end
