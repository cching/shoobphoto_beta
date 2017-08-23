json.array!(@prints) do |print|
  json.extract! print, :id
  json.url print_url(print, format: :json)
end
