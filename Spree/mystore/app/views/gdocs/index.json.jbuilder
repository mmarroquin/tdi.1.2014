json.array!(@gdocs) do |gdoc|
  json.extract! gdoc, :id
  json.url gdoc_url(gdoc, format: :json)
end
