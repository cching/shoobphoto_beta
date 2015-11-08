class SearchtermItem < ActiveRecord::Base
	belongs_to :item
	belongs_to :searchterm
end
