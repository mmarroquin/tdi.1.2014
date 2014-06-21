class Offer < ActiveRecord::Base
	def self.publicarTwitter
		fActual =(DateTime.now)
		fa=(DateTime.strptime((fActual.to_i/1000).to_s,"%s"))
		off = Offer.where(:fuePublicado=>false)
		off.each do |oferta|
			if segundo_antes_primero(fActual,oferta.inicio) and segundo_antes_primero(oferta.fin, fActual)
				producto = WebProduct.where(:sku=>oferta.sku).last
				nombre = producto.name
				precio = oferta.precio
				mensaje = "Nueva oferta en Central Ahorro!!! " + nombre + "a sólo $" + precio + " válido hasta el " + oferta.fin.strftime("%x") + " bit.ly/1uPHoPN"
				Tweet.publish(mensaje)
				Offer.where(:sku=>oferta.sku).last.update_attributes(:fuePublicado=>true)
			end 
		end
	end

	def self.segundo_antes_primero(ahora, inicio)
		if ahora.year > inicio.year
			return true
		else
			if ahora.month > inicio.month
				return true
			else
				if ahora.day > inicio.day
					return true
				else
					if ahora.hour > inicio.hour
						return true
					else
						if ahora.min > inicio.min
							return true
						else
							if ahora.sec > inicio.sec
								return true
							end
						end
					end
				end
			end
		end

		return false
	end
end
