json.array!(@jobs) do |job|
  json.extract! job, :id, :scode, :account, :date, :job, :jobtype, :package_id
  json.url job_url(job, format: :json)
end
