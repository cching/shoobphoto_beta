json.array!(@pages) do |page|
  json.extract! page, :id, :title, :body, :slug, :lft, :rgt, :parent_id
  json.url page_url(page, format: :json)
end
