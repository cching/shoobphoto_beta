class AddonSheet < ActiveRecord::Base
	belongs_to :order_package
	belongs_to :addon
	belongs_to :senior_image
end
