Class DataWarehouse::DeliveryOrder
include Mongoid::Document

field :client_id, type: String
field :order_id, type: String
field :quantitySent, type: Integer
field :address, type: String # Guardar full adress
field :deliveryDate, type: Date

end