json.array!(@reports) do |report|
  json.extract! report, :id, :n_pedido, :despachado, :quiebre, :fecha
  json.url report_url(report, format: :json)
end
