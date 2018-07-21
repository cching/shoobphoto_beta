module DprojectsHelper
	def sortable(column, sorted_column, title: nil, direction: 'asc')
		opposite_direction = direction =='asc' ? 'desc' : 'asc'
		capture do
			concat link_to(title || column.titleize, sort: column, direction: opposite_direction)
			concat sorting_arrows(column, direction, sorted_column)
		end
	end

	def sorting_arrows(column, direction, sorted_column)
		content_tag :span, nil, class: 'sort-container' do
			concat content_tag(:span, nil, class: "glyphicon glyphicon-chevron-up arrow-up #{'active' if direction == 'desc' && column == sorted_column}")
			concat content_tag(:span, nil, class: "glyphicon glyphicon-chevron-down arrow-down #{'active' if direction == 'asc' && column == sorted_column}")
		end
	end
end