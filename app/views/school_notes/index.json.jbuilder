json.array!(@school_notes) do |school_note|
  json.extract! school_note, :id, :cdscode, :name, :district_id, :city_id, :address, :phone, :principle, :secretary
  json.url school_note_url(school_note, format: :json)
end
