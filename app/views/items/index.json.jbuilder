json.array!(@items) do |item|
  json.extract! item, :id, :name, :price, :item_id, :per_page
  json.url item_url(item, format: :json)
end
