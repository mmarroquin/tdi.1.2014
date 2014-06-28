class Reposicion < ActiveRecord::Base
	def self.reponer
		fActual =(DateTime.now)
		fa=(DateTime.strptime((fActual.to_i/1000).to_s,"%s"))
		rep = Reposicion.where(:fueRepuesto=>false)
		rep.each do |repos|
			if segundo_antes_primero(fActual,repos.fecha)
				almacenOrigen =repos.almacenId.to_s
				sku = repos.sku.to_s
				id=repos.id
				Reposicion.where(:id=>id).last.update_attributes(:fueRepuesto=>true)
				depots = Stock.getDepots
	    		almacenPrincipal_id = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first["_id"]
				Stock.movStockSku (almacenOrigen, almacenPrincipal_id, sku, 1, false)
			end 
		end
	end

	def self.segundo_antes_primero(ahora, inicio)
		a =ahora.to_i
		i= inicio.to_i
		return (a>i)
	end

end
