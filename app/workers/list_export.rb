class ListExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export_list = ExportList.find(id)
      require 'csv'
  
          csv_file_setup = ''

          csv_file_setup << CSV.generate_line(['scode'] + ['name'] + ['abbrev'] + ['time_per'] + ['awd_date'] + ['rec_by'] + ['labelfile'] + ['award_id'] + ['trait'])

            export_list.award_infos.where(:processed => false).each do |award|
               csv_file_setup << CSV.generate_line(["#{export_list.user.school.scode}"] + ["#{award.award.title}"] + ["#{award.award.abbreviation}"] + ["#{award.time_period}"] + ["#{award.award_date}"]+  ["#{award.receive_by}"] + ["#{File.basename award.award.image_file_name, '.jpg'}"] + ["#{award.award.abbreviation.humanize}#{award.id}"] + ["#{award.awarded_for}"])
            end
          

          csv_file = ''

          csv_file << CSV.generate_line(['scode'] + ['shoob_id'] + ['st_stu_id'] + ['st_fname'] + ['st_lname'] + ['st_grade'] + ['st_teacher'] + ['image'] + ['award'] + ['st_id'] + ['trait'])

            export_list.award_infos.where(:processed => false).each do |award|
              award.award_info_students.each do |award_student|
                @image = student.school.packages.where(hidden: false).where("name like ?", "%Fall%").last

                if @image.nil?
                  @image = award_student.student.school.packages.first
                end
                img = @image.student_images.where(:student_id => award_student.student_id)
                @string = @string2 = ""
                if img.any?
                  @string2 = "#{img.last.image.url}"
                  @string = "#{img.last.try(:image_file_name)}"
                end
               csv_file << CSV.generate_line(["#{award_student.student.school.scode}"] + ["#{award_student.student.shoob_id}"] + ["#{award_student.student.student_id}"] + ["#{award_student.student.first_name}"] + ["#{award_student.student.last_name}"] + ["#{award_student.student.grade}"] + ["#{award_student.student.teacher}"] + ["#{@string2}"] + ["#{File.basename award.award.image_file_name, '.jpg'}"] + ["#{@string}"] + ["#{award_student.trait}"])
             end
            end
          

          name = "#{export_list.user.school.name}_#{export_list.created_at}"
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



  end
end
