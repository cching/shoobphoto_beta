class OrderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Order.all.first.attributes.keys[0..12].map{|column| column} + Order.all.first.attributes.keys[14..21].map{|column| column} + ['Price'] + ['Student First Name'] + ['Student Last Name'] + ['Student Teacher'] + ['Student ID'] + ['Student Grade'] + ['Student SChool'] + ['Student DoB'] + ['Type'] + ['Package'] + ['8x10 | 5x7 | 3x5 | Wallets | Image CD | Name on Wallets | Retouching'] + ['CA Code'] + ['Senior Image'] + ['Year'])

            Order.all.where.not(processed: true).order(:id).each do |order|
              order.cart.students.each do |student|
                @string1 = ""
                @string2 = ""

              if order.cart.order_packages.where(:student_id => student.id).count > 1

                @string = order.cart.order_packages.where(:student_id => student.id).collect { |w| w.package.slug }.join(", ")
              else
                @string = ""
                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  @string = @string + "#{opackage.package.slug}"
                end
              end

              unless order.cart.order_packages.where(:student_id => student.id).count == 0

              if order.cart.order_packages.where(:student_id => student.id).count > 1

                @string2 = []

                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  if opackage.package.id == 1
                    @string2 << "#{opackage.option.name[0]}"
                  else
                    @string2 << "#{opackage.option.name[-1]}"
                  end
                end

                @string2 = @string2.join(", ")
              else
                @string2 = ""
                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  if opackage.package.id == 1
                    @string2 = @string2 + "#{opackage.option.name[0]}"
                  else
                    @string2 = @string2 + "#{opackage.option.name[-1]}"
                  end
                end         
              end
              end

              unless order.cart.order_packages.where(:student_id => student.id).last.download_image.nil?
                @year = order.cart.order_packages.where(:student_id => student.id).last.download_image.year
              end
              
              csv_file << CSV.generate_line(order.attributes.values[0..12] + order.attributes.values[14..21] + ["#{Order.price(order.id, student.id)}"] +
                ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.teacher}"] + ["#{student.student_id}"] + ["#{student.grade}"] + ["#{student.school.name}"] + ["#{student.dob}"] + 
                
              
             [@string] + [@string2] + [Package.concat(order.id, student.id)] + [order.cart.school.try(:ca_code)] + [order.cart.order_packages.where(:student_id => student.id).last.try(:url)] + [@year]
                

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
