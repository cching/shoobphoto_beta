class SMSService::API::Client

  def initialize()
    @client = Twilio::REST::Client.new(ENV['TWILIO_SID'], ENV['TWILIO_TOKEN'])
    @sender_phone = ENV['TWILIO_NUMBER']
  end

  def send_mms(message, media_url, receiver)
    @client.messages.create(
      body: message,
      from: @sender_phone,
      media_url: media_url,
      to: receiver
    )
  end
  
end