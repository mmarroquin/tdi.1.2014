json.array!(@pedidos) do |pedido|
  json.extract! pedido, :id, :nombrecliente, :created_at, :address, :state, :latitude, :longitude
  json.url pedido_url(pedido, format: :json)
end
