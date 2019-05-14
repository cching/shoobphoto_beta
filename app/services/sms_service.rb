module SMSService
  module_function

  def send_mms_from_csv(file)
    file.each do |row|
      data = row.to_hash
      send_mms(data['phone'], data['shoob_id'], data['folder'], data['message'])
    end
  end

  def send_mms(receiver, shoob_id, folder, message)
    timage = StudentImage.includes(:package, student: :school)
                         .where(shoob_id: shoob_id, folder: folder)
                         .take

    return false if timage.nil?

    media_url = timage.image.url

    client = SMSService::API::Client.new
    client.send_mms(message, receiver, media_url)
  end
end