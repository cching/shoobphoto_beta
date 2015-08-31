json.array!(@corders) do |corder|
  json.extract! corder, :id, :cart_id, :ip_address, :first_name, :last_name, :phone, :email, :address, :city, :state, :zip_code, :card_type, :card_expires_on, :price, :shipping_address, :shipping_city, :shipping_zip, :shipping_state, :processed, :notes
  json.url corder_url(corder, format: :json)
end
