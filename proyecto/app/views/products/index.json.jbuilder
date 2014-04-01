json.array!(@products) do |product|
  json.extract! product, :id, :name, :password, :description, :stock, :price, :sku
  json.url product_url(product, format: :json)
end
