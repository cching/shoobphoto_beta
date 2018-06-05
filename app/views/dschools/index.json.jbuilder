json.array!(@dschools) do |dschool|
  json.extract! dschool, :id, :scode, :name
  json.url dschool_url(dschool, format: :json)
end
