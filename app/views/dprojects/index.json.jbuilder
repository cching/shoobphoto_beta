json.array!(@dprojects) do |dproject|
  json.extract! dproject, :id
  json.url dproject_url(dproject, format: :json)
end
