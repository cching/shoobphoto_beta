class SendText
  include Sidekiq::Worker
  sidekiq_options queue: "package_import"

   def perform(phone, shoob_id, folder)
    image = StudentImage
      .includes(:package, student: :school)
      .where(shoob_id: shoob_id, folder: folder)
      .take
    
    return if image.nil? || image.student.nil? || image.package.nil? || phone.nil? || image.watermark_file_name.nil?

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

    image.watermark.reprocess!

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