class ExportDataStudent < ActiveRecord::Base
	belongs_to :student
	belongs_to :export_data
	validates_uniqueness_of :student_id, scope: :export_data_id
end
