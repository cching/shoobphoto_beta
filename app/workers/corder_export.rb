class CorderExport
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"
  def perform(id)
    export = Export.find(id)
    require 'csv'
    
    csv_file = ''

    Corder.all.each do |order|
      @string1 = ""


      @items = order.cart.items.order(:number)

      @i = 0

        @items[0..39].each do |item|
          citem = order.cart.cart_items.where(:item_id => item.id).last
          @string1 = @string1 + "#{item.number}, #{item.name}, #{citem.quantity}, #{render_quantity(citem)}\n"
        end
        @i = @i + 1

        csv_file << CSV.generate_line([@string1])
      end
          
      file_name = Rails.root.join('tmp', "order_#{Time.now.day}-#{Time.now.month}-#{Time.now.year}_#{Time.now.hour}_#{Time.now.min}.csv");

      File.open(file_name, 'wb') do |file|
        file.puts csv_file
    end
          
      s3 = AWS::S3.new
          
      key = File.basename(file_name)
          
      file = s3.buckets['shoobphoto'].objects["csvs/#{key}"].write(:file => file_name)
      file.acl = :public_read

      export.update(:file_path => key)
  end

  def render_quantity(cart_item)
    if cart_item.download?
      return 1
    elsif cart_item.product?
      return 2
    elsif cart_item.both? 
      return 3
    end
  end
end
