json.array!(@projects) do |project|
  json.extract! project, :id, :school, :email, :name, :position, :phone, :delivery, :flexible
  json.url project_url(project, format: :json)
end
