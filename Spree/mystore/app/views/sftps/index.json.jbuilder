json.array!(@sftps) do |sftp|
  json.extract! sftp, :id
  json.url sftp_url(sftp, format: :json)
end
