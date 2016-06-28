class Sheet < ActiveRecord::Base
	belongs_to :order_package
	belongs_to :senior_image
end
