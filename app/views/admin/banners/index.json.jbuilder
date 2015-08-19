json.array!(@banners) do |banner|
  json.extract! banner, :id, :school_id
  json.url banner_url(banner, format: :json)
end
