class ExportContact
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = ContactExport.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['id'] + ['name'] +  ['school'] + ['student'] + ['grade'] + ['teacher_name'] + ['address'] + ['city'] + ['email'] + ['phone'] + ['message'] + ['admin'] + ['teacher'] + ['parent'] + ['created_at'] + ['updated_at'] + ['jobseeker'] + ['file_file_name'] + ['file_content_type'] + ['file_file_size'] + ['file_updated_at'])
        Contact.order(:name).each do |contact|

          csv_file << CSV.generate_line(["#{contact.id}", "#{contact.name}", "#{contact.school}", "#{contact.student}", "#{contact.grade}", "#{contact.teacher_name}", "#{contact.address}", "#{contact.city}", "#{contact.email}", "#{contact.phone}", "#{contact.message}", "#{contact.admin}", "#{contact.teacher}", "#{contact.parent}", "#{contact.created_at}", "#{contact.updated_at}", "#{contact.jobseeker}", "#{contact.file_file_name}", "#{contact.file_content_type}", "#{contact.file_file_size}", "#{contact.file_updated_at}"]) 

        
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



