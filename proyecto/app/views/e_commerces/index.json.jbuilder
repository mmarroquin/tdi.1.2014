json.array!(@e_commerces) do |e_commerce|
  json.extract! e_commerce, :id
  json.url e_commerce_url(e_commerce, format: :json)
end
