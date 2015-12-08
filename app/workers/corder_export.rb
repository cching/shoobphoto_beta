class CorderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Corder.all.first.attributes.keys[0..12].map{|column| column} + Corder.all.first.attributes.keys[14..21].map{|column| column}  + ['School'] + ['Price'] + ['Items'])
            Corder.where(:processed => false).each do |order|

              
              
              @string = ""
                
              order.cart.items.each do |item|
                citem = order.cart.cart_items.where(:item_id => item.id).last
                @string = @string + "#{item.number}, #{item.name}, #{citem.quantity}; "
              end
     
                csv_file << CSV.generate_line(order.attributes.values[0..12] + order.attributes.values[14..21] + ["#{order.schools}"] + ["#{order.price.to_i}"] + [@string]

              ) 
            
          end
          
          file_name = Rails.root.join('tmp', "order_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

          File.open(file_name, 'wb') do |file|
          
            file.puts csv_file
          end

          s3 = AWS::S3.new

          key = File.basename(file_name)

          file = s3.buckets['shoobphoto'].objects["csvs/#{key}"].write(:file => file_name)
          file.acl = :public_read

          export.update(:file_path => key)
  end
end
