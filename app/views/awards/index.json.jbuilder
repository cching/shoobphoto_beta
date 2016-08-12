json.array!(@awards) do |award|
  json.extract! award, :id, :title, :abbreviation, :awarded_for, :definition, :time_period, :award_date, :export_list_id
  json.url award_url(award, format: :json)
end
