class OptionCart < ActiveRecord::Base
	belongs_to :order_package
	belongs_to :option

	validates :order_package_id, uniqueness: {:scope => [:option_id]}
end
