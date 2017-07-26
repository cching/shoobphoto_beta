class ExportSchool
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = SchoolExport.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['lastname'] + ['firstname'] +  ['image file name'])
          School.find(198).students.where(id_only: true).each do |student|

            student_images = student.student_images.where(:folder => "fall2017")
            image = ""
            if student_images.any?
              image = student_images.last.image_file_name
            end
            csv_file << CSV.generate_line(["#{student.last_name}"] + ["#{student.first_name}"] + ["#{image}"])

            
          end
        
          file_name = Rails.root.join('tmp', "school_export_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

          File.open(file_name, 'wb') do |file|
          
            file.puts csv_file
          end

          s3 = AWS::S3.new

          key = File.basename(file_name)

          file = s3.buckets['shoobphoto'].objects["csvs/#{key}"].write(:file => file_name)
          file.acl = :public_read

          export.update(:file_file_name => key)
    end
end