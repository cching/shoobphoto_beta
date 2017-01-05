class ListExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export_list = ExportList.find(id)
      require 'csv'
  
          csv_file_setup = ''

          csv_file_setup << CSV.generate_line(['scode'] + ['name'] + ['abbrev'] + ['time_per'] + ['awd_date'] + ['rec_by'] + ['labelfile'] + ['award_id'])

            export_list.award_infos.where(:processed => false).each do |award|
               csv_file_setup << CSV.generate_line(["#{export_list.user.school.scode}"] + ["#{award.award.title}"] + ["#{award.award.abbreviation}"] + ["#{award.time_period}"] + ["#{award.award_date}"]+  ["#{award.receive_by}"] + ["#{award.award.image_file_name}"] + ["#{award.award.abbreviation.humanize}#{award.id}"])
            end
          

          csv_file = ''

          csv_file << CSV.generate_line(['scode'] + ['shoob_id'] + ['st_stu_id'] + ['st_fname'] + ['st_lname'] + ['st_grade'] + ['st_teacher'] + ['image'] + ['award'] + ['st_id'])

            export_list.award_infos.where(:processed => false).each do |award|
              award.students.each do |student|
                @image = student.school.packages.where("name like ?", "%Fall%").last

                if @image.nil?
                  @image = student.school.packages.first
                end
                img = @image.student_images.where(:student_id => student.id)
                @string = ""
                @string2 = ""
                if img.any?
                  @string2 = "#{img.last.image.url}"
                  @string = "#{img.last.try(:image_file_name)}.jpg"
                end
               csv_file << CSV.generate_line(["#{student.school.scode}"] + ["#{student.shoob_id}"] + ["#{student.student_id}"] + ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.grade}"] + ["#{student.teacher}"] + ["#{@string2}"] + ["#{award.award.abbreviation.humanize}#{award.id}"] + ["#{@string}"])
             end
            end
          

          name = "awards_#{export_list.created_at}"
          file_name = Rails.root.join('tmp', "#{name}");

          file_name_setup = Rails.root.join('tmp', "#{name}-setup");

          File.open(file_name, 'wb') do |file|
          
            file.puts csv_file
          end

          File.open(file_name_setup, 'wb') do |file|
          
            file.puts csv_file_setup
          end

          s3 = AWS::S3.new

          key = File.basename(file_name)

          file = s3.buckets['shoobphoto'].objects["csvs/#{key}"].write(:file => file_name)
          file.acl = :public_read

          key_setup = File.basename(file_name_setup)

          file_setup = s3.buckets['shoobphoto'].objects["csvs/#{key_setup}"].write(:file => file_name_setup)
          file_setup.acl = :public_read

          export_list.update(:file_path => key)


          ExportMailer.send_mail(export_list).deliver 

  end
end
