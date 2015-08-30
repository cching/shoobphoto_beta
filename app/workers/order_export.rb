class OrderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(chunk)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Order.all.first.attributes.keys[0..12].map{|column| column} + Order.all.first.attributes.keys[14..21].map{|column| column} + ['Price'] + ['Student First Name'] + ['Student Last Name'] + ['Student Teacher'] + ['Student ID'] + ['Student Grade'] + ['Student SChool'] + ['Student DoB'] + ['Type'] + ['Package'] + ['8x10 | 5x7 | 3x5 | Wallets | Image CD | Name on Wallets | Retouching'])
            Order.where(:processed => false).each do |order|
              order.cart.students.each do |student|

              if order.cart.order_packages.where(:student_id => student.id).count > 1

                @string = order.cart.order_packages.where(:student_id => student.id).collect { |w| w.package.slug }.join(", ")
              else
                @string = ""
                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  @string = @string + "#{opackage.package.slug}"
                end
              end

              if order.cart.order_packages.where(:student_id => student.id).count > 1

                @string2 = order.cart.order_packages.where(:student_id => student.id).collect { |w| w.option.name[-1] }.join(", ")
              else
                @string2 = ""
                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  @string2 = @string2 + "#{opackage.option.name[-1]}"
                end         
              end
              
              csv_file << CSV.generate_line(order.attributes.values[0..12] + order.attributes.values[14..21] + ["#{Order.price(order.id, student.id)}"] +
                ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.teacher}"] + ["#{student.student_id}"] + ["#{student.grade}"] + ["#{student.school.name}"] + ["#{student.dob}"] + 
                
              
             [@string] + [@string2] + [Package.concat(order.id, student.id)]
                

              )
          end
          end
          file_name = Rails.root.join('tmp', "order_#{Time.now}.csv");

          File.open(file_name, 'wb') do |file|
          
            file.puts csv_file
          end

          bucket = AWS::S3::Bucket.new('shoobphoto')

          AWS::S3::S3Object.store(
          File.basename(file_name),
          File.open(file_name),
          bucket,
          :content_type => 'csv'
          )
  end
end

