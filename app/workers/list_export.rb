class ListExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export_list = ExportList.find(id)
      require 'csv'

      csv_file = ''
      school = export_list.user.school
      package = school.packages.where("name like ?", "%Fall%").last
      @any = false

      bucket = AWS::S3::Bucket.new('shoobphoto')
      compressed_filestream = Zip::ZipOutputStream.write_buffer do |zos|

            
          csv_file << CSV.generate_line(['Student ID'] + ['First Name'] + ['Last Name'] + ['Grade'] + ['Teacher'] + ['Image'])
            export_list.user.students.each do |student|
              if package.student_images.where(:student_id => student.id).any?
                @string = "#{package.student_images.where(:student_id => student.id).last.image.url}"

                image = package.student_images.where(:student_id => student.id)
                if image.last.try(:folder).nil? && (image.last.downloaded == false)
                  puts "2@@@@@ #{image.last}"
                    title = "#{student.last_name}_#{student.first_name}.jpg"
                    zos.put_next_entry("images/#{title}")
                    url1_data = open(image.last.image.url)
                    z.osprint IO.read(url1_data)

                    image.last.update(:downloaded => true)
                    @any = true
                end

              else
                @string = ""
              end ## end if

                csv_file << CSV.generate_line(["#{student.student_id}"] + ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.grade}"] + ["#{student.teacher}"] + [@string]

              ) 
             
          end ## end loop
          
      end ## end zip file

          if @any
            s3 = AWS::S3.new

            @tkey = "#{Time.now}-zip"
            compressed_filestream.rewind
            bucket.put("zips/#{@tkey}.zip", compressed_filestream.read, {}, 'authenticated-read')

          end
          
          file_name = Rails.root.join('tmp', "#{export_list.title}_#{export_list.created_at}.csv");

          File.open(file_name, 'wb') do |file|
            file.puts csv_file
          end 

          s3 = AWS::S3.new

          key = File.basename(file_name)

          file = s3.buckets['shoobphoto'].objects["csvs/#{key}"].write(:file => file_name)
          file.acl = :public_read

          export_list.update(:file_path => key)
          ExportMailer.send_mail(export_list, @tkey).deliver

  end
end
