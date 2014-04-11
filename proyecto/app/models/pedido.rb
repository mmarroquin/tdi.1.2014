class Pedido < ActiveRecord::Base
	has_many :products
	
	geocoded_by :address
	after_validation :geocode

end
