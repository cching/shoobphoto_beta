module DprojectsHelper
	def sortable(column, title = nil)
		title ||= column.titleize
		link_to title, :sort => column
	end
end
