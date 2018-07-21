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
			concat content_tag(:span, nil)
			concat content_tag(:span, nil)
		end
	end
end