class ExportSchool
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['Database ID'] + ['School Name'] +  ['CA Code'] + ['Type'] + ['Package Name'] + ['Shipping'])
          School.all.each do |school|
            school.packages.each do |package|
              if package.shippings.where(:school_id => student.school.id).any?
                @price = package.shippings.where(:school_id => student.school.id).first.try(:price)
              elsif package.shippings.where(:school_id => nil).any?
                @price = package.shippings.where(:school_id => nil).first.try(:price)
              end

              csv_file << CSV.generate_line(["#{school.id}"] + ["#{school.name}"] + ["#{school.ca_code}"] + ["#{school.school_type}"] + ["#{package.name}"] + ["#{@price}"])

            end
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