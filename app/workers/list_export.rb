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
      t = Tempfile.new("my-temp-filename-#{Time.now}")
      Zip::OutputStream.open(t.path) do |z|
            
          csv_file << CSV.generate_line(['Student ID'] + ['First Name'] + ['Last Name'] + ['Grade'] + ['Teacher'] + ['Image'])
            export_list.user.students.each do |student|
              if package.student_images.where(:student_id => student.id).any?
                @string = "#{package.student_images.where(:student_id => student.id).last.image.url}"

                image = package.student_images.where(:student_id => student.id)
                if image.last.try(:folder).nil? && (image.last.downloaded == false)
                    title = "#{student.last_name}_#{student.first_name}.jpg"
                    z.put_next_entry("images/#{title}")
                    url1_data = open(image.last.image.url)
                    z.print IO.read(url1_data)

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
            file = s3.buckets['shoobphoto'].objects["zips/#{@tkey}"].write(:file => t)
            file.acl = :public_read

          end
          t.close
          
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
