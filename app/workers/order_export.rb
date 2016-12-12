class OrderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(Order.all.first.attributes.keys[0..12].map{|column| column} + Order.all.first.attributes.keys[14..21].map{|column| column} + ['Price'] + ['Student First Name'] + ['Student Last Name'] + ['Student Teacher'] + ['Student ID']  + ['Student Grade'] + ['Student SChool']  + ['Type'] + ['Package'] + ['8x10 | 5x7 | 3x5 | Wallets | Image CD | Name on Wallets | Retouching'] + ['CA Code'] + ['Senior Image'] + ['Grad Image'] + ['Year'] + ['Extra Poses'] + ['Sheet Types'] + ['Yearbook Image']+ ['Access Code'] + ['Gift'])

            Order.all.where(:processed => false).order(:id).each do |order|
              #Order.where("created_at >= ?", Date.strptime("07/01/2016", "%m/%d/%Y")).each do |order|
              order.cart.students.each do |student|

                @string1 = ""
                @string2 = ""
                @string3 = ""
 
                @year = ""

                @extra_poses = ""
                @yearbook_pose = ""
                @sheet = ""
              
              if order.cart.order_packages.where(:student_id => student.id).where.not(download_image_id: nil).any?
                 @year = "#{order.cart.order_packages.where(:student_id => student.id).where.not(download_image_id: nil).map{ |o| o.download_image.image.url if o.download_image.image.exists?}.join(",")}"
              end



              if order.cart.order_packages.where(:student_id => student.id).count > 1

                @string = order.cart.order_packages.where(:student_id => student.id).collect { |w| w.package.try(:slug) }.join(", ")
              else
                @string = ""
                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  @string = @string + "#{opackage.package.try(:slug)}"
                end
              end


                @string2 = ""

                order.cart.order_packages.where(:student_id => student.id).each do |opackage|
                  if opackage.package.try(:id) == 6
                    @extra_poses = @extra_poses + "#{opackage.try(:extra_poses)}; "
                    @yearbook_pose = @yearbook_pose + "#{opackage.try(:yearbook_poses)}; "
                  end

                  if opackage.package.try(:id) == 6 && opackage.sheets.any?
                    ImageType.find(opackage.sheets.pluck(:image_type_id).uniq).each do |image_type|
                      opackage.sheets.where(:image_type_id => image_type.id).each do |sheet|
                        @sheet = @sheet + "(#{ImageType.count_types(image_type.id)}) #{ImageType.name_out(image_type.id)}:  #{sheet.senior_image.try(:url)},"
                      end
                    end
                    @sheet = @sheet + "; "
                  end

                  opackage.options.each_with_index do |option, i|
                    if i + 1 == opackage.options.count
                      if opackage.package.try(:id) == 1
                        @string2 = @string2 + "#{option.name[0]}; "
                      elsif opackage.package.try(:id) == 6
                        @string2 = @string2 + "#{option.name[8]}; "
                      else
                        @string2 = @string2 +  "#{option.name[-1]}; "
                      end
                    else
                      if opackage.package.try(:id) == 1
                        @string2 = @string2 +  "#{option.name[0]}, "
                      elsif opackage.package.try(:id) == 6
                        @string2 = @string2 +  "#{option.name[8]}, "
                      else
                        @string2 = @string2 +  "#{option.name[-1]}, "
                      end # end if
                    end #end if
                  end   #end loop

                    opackage.gifts.each_with_index do |gift, i|
                      @string2 = @string2 + "#{gift.number}; "
                    end   #end loop
                  

                  if opackage.gifts.any?
                  opackage.gifts.each_with_index do |gift, i|
                    @string3 = @string3 + "#{gift.number}, #{opackage.quantity}; "
                  end   #end loop
                  end


                end

              csv_file << CSV.generate_line(order.attributes.values[0..12] + order.attributes.values[14..21] + ["#{Order.price(order.id, student.id)}"] +
                ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.teacher}"] + ["#{student.student_id}"] + ["#{student.grade}"] + ["#{student.school.try(:name)}"]  +     
                [@string] + [@string2] + [Package.concat(order.id, student.id)] + [order.cart.school.try(:ca_code)] + [order.cart.order_packages.where(:student_id => student.id).last.try(:url)] + [order.cart.order_packages.where(:student_id => student.id).last.try(:grad)] + [@year] + [@extra_poses] + [@sheet] + [@yearbook_pose] + ["#{student.try(:access_code)}"] + [@string3]
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
