json.array!(@dprojects) do |dproject|
  json.extract! dproject, :id, :id, :scode, :completed_at, :description
  json.url dproject_url(dproject, format: :json)
end
