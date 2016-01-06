json.array!(@yearbooks) do |yearbook|
  json.extract! yearbook, :id, :date, :quantity, :amount
  json.url yearbook_url(yearbook, format: :json)
end
