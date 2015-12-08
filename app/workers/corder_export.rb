class CorderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
    def perform(id)
      export = Export.find(id)
      require 'csv'

      csv_file = ''

        csv_file << CSV.generate_line(['ID'] + ['School'] + ['Student'] + ['Price'] + ['Created at'] + ['Purchased?'] + ["Student found"])
              Cart.where("created_at >= ?", 1.week.ago.utc).where.not(cart_type: nil).each do |cart|
                cart.students.each do |student|

        @price = 0

          cart.order_packages.where(:student_id => student.id).each do |package|
           @price = package.option.price(student.school.id) + @price
          end

          cart.order_packages.where(:student_id => student.id).each do |opackage|
            package = opackage.package
            if package.shippings.where(:school_id => cart.students[params[:i].to_i].school.id).any?
            @price = @price + package.shippings.where(:school_id => @cart.students[params[:i].to_i].school.id).first.price
            elsif package.shippings.where(:school_id => nil).any?
            @price = @price + package.shippings.where(:school_id => nil).first.price
            
            end
          end

        csv_file << CSV.generate_line(["#{cart.id}"] + ["#{student.school.name}"] + ["$#{@price}"] + ["#{cart.created_at}"] + ["#{cart.purchased}"] + ["#[cart.id_supplied]"])


      end




  end
end
