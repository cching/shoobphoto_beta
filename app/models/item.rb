class Item < ActiveRecord::Base
	has_many :cart_items, dependent: :destroy
	has_many :carts, through: :cart_items

	has_many :images
end
