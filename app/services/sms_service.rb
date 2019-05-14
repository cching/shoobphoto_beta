module SMSService
  module_function

  def send_mms_from_csv(file)
    csv = CSV.parse(file, headers: true)
    csv.each do |row|
      data = row.to_hash
      send_single_mms(data['phone'], data['shoob_id'], data['folder'], data['message'])
    end
  end

  def send_single_mms(receiver, shoob_id, folder, message)
    timage = StudentImage.includes(:package, student: :school)
                         .where(shoob_id: shoob_id, folder: folder)
                         .take

    return false if timage.nil?

    # cart = Cart.new(
    #   cart_id: (0...8).map { (65 + rand(26)).chr }.join
    # )

    # cart.school = timage.student.school
    # cart.students = [timage.student]

    # cart.save

    media_url = timage.image.url

    client = SMSService::API::Client.new
    client.send_mms(message, media_url, receiver)
  end
end