class Offer < ActiveRecord::Base
	def self.publicarTwitter
		fActual =(DateTime.now)
		fa=(DateTime.strptime((fActual.to_i/1000).to_s,"%s"))
		off = Offer.where(:fuePublicado=>false)
		off.each do |oferta|
			if segundo_antes_primero(fActual,oferta.inicio) and segundo_antes_primero(oferta.fin, fActual)
				producto = WebProduct.where(:sku=>oferta.sku).last
				nombre = producto.name
				if nombre.length > 65
					nombre = nombre [0,50] + "..."
				end
				precio = oferta.precio
				mensaje = "#ofertagrupo1 Oferta! " + nombre + " a solo S" + precio + " valido hasta el " + oferta.fin.strftime("%x") + " bit.ly/1uPHoPN"
				puts mensaje.length
				Tweet.publish(mensaje)
				Offer.where(:sku=>oferta.sku).last.update_attributes(:fuePublicado=>true)
				precioB = producto.price_internet
				Offer.where(:sku=>oferta.sku).last.update_attributes(:precioBase=>precioB)
				WebProduct.where(:sku=>oferta.sku).last.update_attributes(:price_internet=>precio)
				Offer.where(:sku=>oferta.sku).last.update_attributes(:TienePrecioBase=>false)
			end 
		end
	end

	def self.segundo_antes_primero(ahora, inicio)
		a =ahora.to_i
		i= inicio.to_i
		return (a>i)
	end

	def self.cambiarPrecio
		fActual =(DateTime.now)
		fa=(DateTime.strptime((fActual.to_i/1000).to_s,"%s"))
		off = Offer.where(:fuePublicado=>true, :TienePrecioBase=>false)
		off.each do |oferta|
			if segundo_antes_primero(fActual,oferta.fin)
				precio = oferta.precioBase
				WebProduct.where(:sku=>oferta.sku).last.update_attributes(:price_internet=>precio)
				Offer.where(:sku=>oferta.sku).last.update_attributes(:TienePrecioBase=>true)
			end 
		end
	end
end
