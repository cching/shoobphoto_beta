class OrderReceipt
	include Sidekiq::Worker
  	sidekiq_options queue: "package_import"

    def perform(order_id)
    	order = Order.find(order_id)
    	OrderMailer.receipt(order).deliver
    end
end
