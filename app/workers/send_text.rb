class SendText
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"

   def perform(phone, shoob_id, folder)
    image = StudentImage
      .includes(:package, student: :school)
      .where(shoob_id: shoob_id, folder: folder)
      .take

    puts "Here is the image: #{image}"

    if image.nil?
      puts "image UNAVAILABLE"
      return

    elsif image.student.nil?
      puts "student UNAVAILABLE"
      return

    elsif image.package.nil?
      puts "package UNAVAILABLE"
      return

    elsif phone.nil?
      puts "phone number UNAVAILABLE"
      return

    elsif image.watermark_file_name.nil?
      puts "watermark ERROR"
      return

    else
      puts image
      puts image.student
      puts image.package
      puts phone
      puts image.watermark_file_name
      puts "Sent to Twilio successfully"
    end

    cart = Cart.new(
      cart_id: (0...8).map { (65 + rand(26)).chr }.join
    )

    cart.school = image.student.school
    cart.students = [image.student]

    cart.save

    client = api_client

    send_mms(client, cart, phone, image)
   end
  
   def send_mms(client, cart, phone, image)
    url = "https://www.shoobphoto.com/students/packages/#{cart.cart_id}/select/0/#{image.package.id}"

    

    client
      .messages
      .create(
        body: "Sale ends tomorrow! Pay for your Spring Picture now and save up to $6! #{image.package.name.strip} now at #{url}",
        from: ENV['TWILIO_NUMBER'],
        media_url: image.watermark.url,
        to: phone
      )
  end

  private

  def api_client
    Twilio::REST::Client.new(ENV['TWILIO_SID'], 
                             ENV['TWILIO_TOKEN'])
  end
end