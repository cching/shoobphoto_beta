json.array!(@extra_types) do |extra_type|
  json.extract! extra_type, :id, :name, :required, :multiple
  json.url extra_type_url(extra_type, format: :json)
end
