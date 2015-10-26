json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :school, :student, :grade, :teacher, :address, :city, :email, :phone, :message, :admin, :teacher, :parent
  json.url contact_url(contact, format: :json)
end
