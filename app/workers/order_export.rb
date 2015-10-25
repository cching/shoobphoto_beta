class OrderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Order.all.first.attributes.keys[0..12].map{|column| column} + Order.all.first.attributes.keys[14..21].map{|column| column} + ['Price'] + ['Student First Name'] + ['Student Last Name'] + ['Student Teacher'] + ['Student ID'] + ['Student Grade'] + ['Student SChool'] + ['Student DoB'] + ['Type'] + ['Package'] + ['8x10 | 5x7 | 3x5 | Wallets | Image CD | Name on Wallets | Retouching'] + ['CA Code'] + ['Senior Image'])
            Order.all.each do |order|

              order.cart.students.each do |student|


              if order.cart.order_packages.where(:student_id => student.id).count > 1
                 @string = ""
                @string2 = ""

                @string = @string + order.cart.order_packages.where(:student_id => student.id).collect { |w| w.package.slug }.join(", ")
                @string2 = @string2 + order.cart.order_packages.where(:student_id => student.id).collect { |w| w.option.try(:name)[-1] }.join(", ")
              elsif order.cart.order_packages.where(:student_id => student.id).count == 1
                @string = ""
                @string2 = ""

                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  @string = @string + "#{opackage.package.slug}"
                  @string2 = @string2 + "#{opackage.option.try(:name)[-1]}"
                end
              else
                @string = ""
                @string2 = ""
              end
              
              csv_file << CSV.generate_line(order.attributes.values[0..12] + order.attributes.values[14..21] + ["#{Order.price(order.id, student.id)}"] +
                ["#{student.try(:first_name)}"] + ["#{student.try(:last_name)}"] + ["#{student.try(:teacher)}"] + ["#{student.try(:student_id)}"] + ["#{student.try(:grade)}"] + ["#{student.school.try(:name)}"] + ["#{student.try(:dob)}"] + 
                
              
             [@string] + [@string2] + [Package.concat(order.id, student.id)] + [order.cart.school.try(:ca_code)] + [order.cart.order_packages.where(:student_id => student.id).try(:url)]
                

              ) 
            
          end
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

