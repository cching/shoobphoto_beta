json.array!(@gifts) do |gift|
  json.extract! gift, :id
  json.url gift_url(gift, format: :json)
end
