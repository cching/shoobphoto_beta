class SendText
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"

   def perform(phone, shoob_id, folder)
    timage = StudentImage
      .includes(:package, student: :school)
      .where(shoob_id: shoob_id, folder: folder)
      .take

    puts "Here is the image: #{timage}"

    if timage.nil?
      puts "image UNAVAILABLE"
      return

    elsif timage.student.nil?
      puts "student UNAVAILABLE"
      return

    elsif timage.package.nil?
      puts "package UNAVAILABLE"
      return

    elsif phone.nil?
      puts "phone number UNAVAILABLE"
      return

    elsif timage.watermark_file_name.nil?
      puts "watermark ERROR"
      return

    else
      puts timage
      puts timage.student
      puts timage.package
      puts phone
      puts timage.watermark_file_name
      puts timage.image.url
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

    timage.watermark.reprocess!

    client
      .messages
      .create(
        body: "Sale ends tomorrow! Pay for your Spring Picture now and save up to $6! #{timage.package.name.strip} now at #{url}",
        from: ENV['TWILIO_NUMBER'],
        media_url: timage.image.url,
        to: phone
      )
  end

  private

  def api_client
    Twilio::REST::Client.new(ENV['TWILIO_SID'], 
                             ENV['TWILIO_TOKEN'])
  end
end