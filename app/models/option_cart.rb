class OptionCart < ActiveRecord::Base
	belongs_to :order_package
	belongs_to :option

end
