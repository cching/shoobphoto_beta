json.array!(@autos) do |auto|
  json.extract! auto, :id
  json.url auto_url(auto, format: :json)
end
