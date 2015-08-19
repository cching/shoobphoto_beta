json.array!(@nav_links) do |nav_link|
  json.extract! nav_link, :id, :title, :slug, :lft, :rgt, :parent_id, :position
  json.url nav_link_url(nav_link, format: :json)
end
