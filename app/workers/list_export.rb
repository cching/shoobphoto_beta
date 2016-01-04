class ListExport
  include Sidekiq::Worker
  sidekiq_options queue: "list_export"
    def perform(id)
      export_list = ExportList.find(id)
      require 'csv'

      csv_file = ''
      school = export_list.user.school
      package = school.packages.where("name like ?", "%Fall%").last

          csv_file << CSV.generate_line(['Student ID'] + ['First Name'] + ['Last Name'] + ['Grade'] + ['Teacher'] + ['Image'])
            export_list.user.students.each do |student|

                csv_file << CSV.generate_line(["#{student.student_id}"] + ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.grade}"] + ["#{student.teacher}"] + ["#{package.student_images.where(:student_id => student.id).last.image.url}"]

              ) 
             
          end
          
          file_name = Rails.root.join('tmp', "export_list_#{export_list.name}_#{export_list.id}.csv");

          File.open(file_name, 'wb') do |file|
            file.puts csv_file
          end 

          s3 = AWS::S3.new

          key = File.basename(file_name)

          file = s3.buckets['shoobphoto'].objects["csvs/#{key}"].write(:file => file_name)
          file.acl = :public_read

          export_list.update(:file_path => key)
          ExportMailer.send_mail(export_list).deliver
  end
end
