class Reposicion < ActiveRecord::Base
	def self.reponer
		fActual =(DateTime.now)
		fa=(DateTime.strptime((fActual.to_i/1000).to_s,"%s"))
		rep = Reposicion.where(:fueRepuesto=>false)
		rep.each do |repos|
			if segundo_antes_primero(fActual,repos.fecha)
				almacen =repos.almacenId
				sku = repos.sku
				id=repos.id
				Reposicion.where(:id=>id).last.update_attributes(:fueRepuesto=>true)
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
