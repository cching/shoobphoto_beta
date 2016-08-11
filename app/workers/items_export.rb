class ItemsExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = SchoolExport.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['Database ID'] + ['Name'] +  ['Number'] + ['Price'] + ['Image URL'] + ['Subcategory'] + ['Search terms'])
          Item.all.order(:id).each do |item|


              csv_file << CSV.generate_line(["#{item.id}"] + ["#{item.name}"] + ["#{item.number}"] + ["#{item.price}"] + ["#{item.main.url}"]  + ["#{item.subcategory.name}"] + ["#{item.searchterms.map(&:name).join(", ")}"])

            
          end
        
          file_name = Rails.root.join('tmp', "item_export#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

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