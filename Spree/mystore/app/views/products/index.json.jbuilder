json.array!(@products) do |product|
  json.extract! product, :id, :sku, :price, :start_date, :final_date
  json.url product_url(product, format: :json)
end
