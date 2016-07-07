json.array!(@addons) do |addon|
  json.extract! addon, :id
  json.url addon_url(addon, format: :json)
end
