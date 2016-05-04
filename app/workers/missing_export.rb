class MissingExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Missing.find(id)
      require 'csv'

      csv_file = ''

          csv_file << CSV.generate_line(['Shoob ID'] + ['Missing URL'] + ['Student ID'] + ['Student First Name'] + ['Student Last Name'] + ['School CA Code'] + ['School Name'])
            DownloadImage.each do |image|

            unless image.image.exists?
                csv_file << CSV.generate_line(["#{image.shoob_id}"] + ["#{image.image.url}"] + ["#{image.student.student_id}"] + ["#{image.student.first_name}"] + ["#{image.student.last_name}"] + ["#{image.student.school.ca_code}"] + ["#{image.student.school.name}"] 

              ) 
            end
            
          end
          
          file_name = Rails.root.join('tmp', "missing_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

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
