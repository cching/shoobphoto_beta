class CartExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['ID'] + ['School'] +  ['Student ID'] + ['Student'] + ['Price'] + ['Created at'] + ['Purchased?'] + ["Student found"] + ["Email"])
              Cart.where("created_at >= ?", 1.week.ago.utc).where(:cart_type => nil).each do |cart|
                cart.students.each do |student|

        @price = 0

        if cart.order_packages.where(:student_id => student.id).any?

          cart.order_packages.where(:student_id => student.id).each do |package|
            unless package.option.nil?
           @price = package.option.price(student.school.id) + @price
         end
          end

        

          cart.order_packages.where(:student_id => student.id).each do |opackage|
            package = opackage.package
            if package.shippings.where(:school_id => student.school.id).any?
            @price = @price + package.shippings.where(:school_id => student.school.id).first.try(:price)
            elsif package.shippings.where(:school_id => nil).any?
            @price = @price + package.shippings.where(:school_id => nil).first.try(:price)
            
            end
          end

      end

        csv_file << CSV.generate_line(["#{cart.id}"] + ["#{student.school.name}"] + ["#{student.student_id}"] + ["#{student.first_name} #{student.last_name}"] + ["$#{@price}"] + ["#{cart.created_at}"] + ["#{cart.purchased}"] + ["#{cart.id_supplied}"] + ["#{cart.email}"])

      end
      end




          
          file_name = Rails.root.join('tmp', "carts_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

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