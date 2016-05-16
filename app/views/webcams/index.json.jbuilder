json.array!(@webcams) do |webcam|
  json.extract! webcam, :id
  json.url webcam_url(webcam, format: :json)
end
