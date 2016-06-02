class OptionCart < ActiveRecord::Base
	belongs_to :order_package
	belongs_to :option

	validates :option_id, uniqueness: {:scope => [:order_package_id]}
end
