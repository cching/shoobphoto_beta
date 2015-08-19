class OrderPackageExtra < ActiveRecord::Base
	belongs_to :extra
	belongs_to :order_packages
end
