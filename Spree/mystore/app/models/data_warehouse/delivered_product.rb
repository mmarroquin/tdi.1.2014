class DataWarehouse::DeliveredProduct
include Mongoid::Document

field :client_id, type: String
field :order_id, type: String
field :sku, type: String
field :quantitySent, type: Integer
field :address, type: String # Guardar full adress
field :deliveryDate, type: Date

	def coordinates
 	  Geocoder.search(address).first.coordinates
	end

end