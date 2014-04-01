json.array!(@clients) do |client|
  json.extract! client, :id, :username, :password
  json.url client_url(client, format: :json)
end
