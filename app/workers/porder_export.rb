class PorderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Porder.first.attributes.keys[0..14].map{|column| column} + ["First Name"] + ["Last Name"] + ["School"] + ["Email"])
            Porder.all.each do |order|

                
                csv_file << CSV.generate_line(order.attributes.values[0..14] + ["#{order.project.first_name}" + ["#{order.project.last_name}" + ["#{order.project.school}"] + ["#{order.project.email}"] + ["#{order.project.first_name}"] + [order.project.project_prints.map {|pprint| "#{pprint.print.name}, #{pprint.quantity, }"}]

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
