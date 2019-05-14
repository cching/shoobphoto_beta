# class SendText
#   include Sidekiq::Worker
#   sidekiq_options queue: "package_import"

#   def perform(phone, shoob_id, folder, message)
#     timage = StudentImage
#       .includes(:package, student: :school)
#       .where(shoob_id: shoob_id, folder: folder)
#       .take

#     # TODO: remove those 'puts' and create error handling in other class/module
#     # maybe information to admin via e-mail? 
#     puts "Here is the image: #{timage}"
#     # TODO: remove if/else if possible and create validation logic for service layer
#     if timage.nil?
#       puts "image UNAVAILABLE"
#       return

#     # elsif timage.student.nil?
#     #   puts "student UNAVAILABLE"
#     #   return

#     # elsif timage.package.nil?
#     #   puts "package UNAVAILABLE"
#     #   return

#     elsif phone.nil?
#       puts "phone number UNAVAILABLE"
#       return

#     elsif timage.watermark_file_name.nil?
#       puts "watermark ERROR"
#       return

#     else
#       puts timage
#       # puts timage.student
#       # puts timage.package
#       puts phone
#       puts timage.watermark_file_name
#       puts timage.url
#     end

#     # cart = Cart.new(
#     #   cart_id: (0...8).map { (65 + rand(26)).chr }.join
#     # )

#     # cart.school = timage.student.school
#     # cart.students = [timage.student]

#     # cart.save

#     # TODO: no info when the cart is not saved

#     client = api_client

#     send_mms(client, phone, timage, message)
#    end
  
#    def send_mms(client, phone, timage, message)
#     # TODO:  is this variable necessary ?
#     # url = "https://www.shoobphoto.com/students/packages/#{cart.cart_id}/select/0/#{timage.package.id}"

#     # timage.watermark.reprocess!

#     url = timage.image.url

#     client
#       .messages
#       .create(
#         body: message,
#         from: ENV['TWILIO_NUMBER'],
#         media_url: url,
#         to: phone
#       )

#     puts "Sent to Twilio successfully"
#   end

#   private

#   def api_client
#     Twilio::REST::Client.new(ENV['TWILIO_SID'], 
#                              ENV['TWILIO_TOKEN'])
#   end
# end