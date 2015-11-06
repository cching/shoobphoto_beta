class OrderImport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      chunk.each do |h|

        order = find_by_id(h["id"])
        order.update(:processed => h["processed"])
        order.save
              
          
      end

  end
end
