class OrderImport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(chunk)
      chunk.each do |h|

        order = Order.find(h["id"])
        order.update(:processed => h["processed"])
        order.save
              
          
      end

  end
end
