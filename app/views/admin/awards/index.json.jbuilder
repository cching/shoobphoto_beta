json.array!(@awards) do |award|
  json.extract! award, :id
  json.url award_url(award, format: :json)
end
