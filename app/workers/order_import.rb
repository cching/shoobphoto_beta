class OrderImport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(chunk)
      chunk.each do |h|

        Zipcode.create(:zip_code => h["zip"])
              
          
      end

  end
end
