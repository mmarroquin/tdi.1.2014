class Reposicion < ActiveRecord::Base
	def self.reponer
		fActual =(DateTime.now)
		fa=(DateTime.strptime((fActual.to_i/1000).to_s,"%s"))
		rep = Reposicion.where(:fueRepuesto=>false)
		rep.each do |repos|
			if segundo_antes_primero(fActual,repos.fecha)
				almacen =repos.almacenId.to_s
				sku = repos.sku.to_s
				id=repos.id
				Reposicion.where(:id=>id).last.update_attributes(:fueRepuesto=>true)
				#Stock.movStockUn(almacen,sku)
			end 
		end
	end

	def self.segundo_antes_primero(ahora, inicio)
		a =ahora.to_i
		i= inicio.to_i
		return (a>i)
	end

end
