class DataWarehouse::BrokenProduct
include Mongoid::Document

field :client_id, type: String
field :order_id, type: String
field :sku,	type: String
field :reason, type: String
field :address, type: String # Guardar full adress
field :deliveryDate, type: Date

end