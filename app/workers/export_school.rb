class ExportSchool
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = SchoolExport.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['cacode'] + ['school'] +  ['school type'] + ['Price Lists'])
          School.all.where.not(school_type_id: nil).order(:name).each do |school|
            array = []
            school.packages.each do |p|
              p.options.each do |o|
                o.extra_types.each do |et|
                  array = et.extras.map {|e| "#{e.name}, #{e.prices.first.price}"}
                end
              end
            end

              csv_file << CSV.generate_line(["#{school.ca_code}", "#{school.name}", "#{school.school_type.name}"] + school.packages.order(:slug).map {|p| "#{p.slug}, #{p.prices.first.price}"} + array) 

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



