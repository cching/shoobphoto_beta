json.array!(@extras) do |extra|
  json.extract! extra, :id, :name, :extra_type_id
  json.url extra_url(extra, format: :json)
end
