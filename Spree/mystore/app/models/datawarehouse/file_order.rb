Class DataWarehouse::FileOrder
include Mongoid::Document

field :client_id, type: String
field :order_id, type: String
field :address, type: String # Guardar full adress
field :success, type: Boolean
field :deliveryDate, type: Date
field :orderDate, type: DateTime

end