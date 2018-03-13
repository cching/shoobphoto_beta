class AwardExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id) 
      require 'csv'

      csv_file_setup = ''

          csv_file_setup << CSV.generate_line(['scode'] + ['name'] + ['abbrev'] + ['time_per'] + ['awd_date'] + ['rec_by'] + ['labelfile'] + ['award_id'] + ['trait'] + ['email'])

          ExportList.all.where(:submitted => true).where(:hidden => false).each do |export_list|
            export_list.award_infos.where(:processed => false).each do |award|
              unless award.award.nil? 
                scode = export_list.user.school.scode if !export_list.user.nil?
               csv_file_setup << CSV.generate_line(["#{scode}"] + ["#{award.award.try(:title)}"] + ["#{award.award.try(:abbreviation)}"] + ["#{award.time_period}"] + ["#{award.award_date}"]+  ["#{award.receive_by}"] + ["#{File.basename award.award.try(:image_file_name), '.jpg'}"] + ["#{award.award.try(:abbreviation)}#{award.id}"] + ["#{award.awarded_for}"] + ["#{export_list.user.email}"])
             end
            end
          end

          csv_file = ''

          csv_file << CSV.generate_line(['scode'] + ['shoob_id'] + ['st_stu_id'] + ['st_fname'] + ['st_lname'] + ['st_grade'] + ['st_teacher'] + ['image'] + ['award'] + ['st_id'] + ['trait'] + ['award_id'] + ['characetr trait'])

          ExportList.all.where(:submitted => true).where(:hidden => false).each do |export_list|
            export_list.award_infos.where(:processed => false).each do |award|
              award.award_info_students.each do |award_student|
                if award_student.student
                  @image = award_student.student.school.packages.where(hidden: false).where("name like ?", "%Fall%").last

                  if @image.nil?
                    @image = award_student.student.school.packages.first
                  end
                  img = @image.student_images.where(:student_id => award_student.student_id)
                  @string = ""
                  @string2 = ""
                  if img.any?
                    @string2 = "#{img.last.image.url}"
                    @string = "#{img.last.try(:image_file_name)}"
                  end
                  unless award.award.nil?
                    csv_file << CSV.generate_line(["#{award_student.student.school.scode}"] + ["#{award_student.student.shoob_id}"] + ["#{award_student.student.student_id}"] + ["#{award_student.student.first_name}"] + ["#{award_student.student.last_name}"] + ["#{award_student.student.grade}"] + ["#{award_student.student.teacher}"] + ["#{@string2}"] + ["#{File.basename award.award.try(:image_file_name), '.jpg'}"] + ["#{@string}"] + ["#{award_student.trait}"] + ["#{award.award.try(:abbreviation)}#{award.id}"] + ["#{award_student.trait}"])
                  end
                end
             end
            end
          end
          
          file_name_setup = Rails.root.join('tmp', "award_setup_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");
          file_name = Rails.root.join('tmp', "award_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

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

          export.update(:file_path => key, :file_path_setup => key_setup)
  end
end
