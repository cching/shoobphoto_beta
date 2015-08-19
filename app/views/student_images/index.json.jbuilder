json.array!(@student_images) do |student_image|
  json.extract! student_image, :id, :package_id, :student_id
  json.url student_image_url(student_image, format: :json)
end
