class ListExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export_list = ExportList.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(['Student ID'] + ['First Name'] + ['Last Name'] + ['Grade'] + ['Teacher'])
            export_list.user.students.each do |student|

                csv_file << CSV.generate_line(["#{student.student_id}"] + ["#{student.first_name}"] + ["#{student.last_name}"] + ["#{student.grade}"] + ["#{student.teacher}"]

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
          current_user.students = []
  end
end
