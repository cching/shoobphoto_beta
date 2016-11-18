class OrderPackageGift < ActiveRecord::Base
	belongs_to :gift
	belongs_to :order_package
end
