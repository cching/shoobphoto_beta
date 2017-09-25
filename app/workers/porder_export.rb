class PorderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Porder.first.attributes.keys[0..14].map{|column| column})
            Porder.all.each do |order|

     
                csv_file << CSV.generate_line(order.attributes.values[0..13] + order.attributes.values[14..21] + [order.try(:residential)] + [order.try(:grade)] + ["#{order.schools}"] +["#{order.district}"] + ["#{order.price.to_i}"] + [@string1] + [@string2] + [@string3] + [@string4] + [@string5] + [@string6] + [@string7] + [@string8] + ["#{order.processed}"]

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
