class Request < ActiveRecord::Base
	

	def self.pedirProducto (almacenId, sku, cant)
		cliente_id = ""
		
		aux = [{:sku => sku, :cant => cant, :clienteId => cliente_id, :api => true}]
		respuesta = Stock.getStock(aux)
		if respuesta[:success]
			return enviarABodega(aux, almacenId)
	
		else
			su["success"] = respuesta[:success]
			cantidadMov["cantMov"] = 0
			return su, cantidadMov, respuesta[:reason]
		end

	end

	def self.enviarABodega(productos, almacenId)
		s["success"] = true
	    user = "grupo1"
	    password = "OuyMG5aD"
	    authorization = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET"))
	    url = "http://bodega-integracion-2014.herokuapp.com/almacenes"
	    response = HTTParty.get(url,:headers => { "Authorization" => "UC "+ user + ":" + authorization})
	    
	    almacenDespacho_id = response.find { |almacen| almacen['despacho'] == true }["_id"]


	    cantidadMov["cantMov"] = 0
	    productos.each do |prod| 

		    cantidadProd = prod[:cant].to_i
				
			url = "http://bodega-integracion-2014.herokuapp.com/stock"
			authorizationStockD = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenDespacho_id + prod[:sku]))
		    responseStockD = HTTParty.get(url,:query => { :almacenId => almacenDespacho_id, :sku => prod[:sku], :limit => cantidadProd },:headers => { "Authorization" => "UC "+ user + ":" + authorizationStockD})

		    url = "http://bodega-integracion-2014.herokuapp.com/moveStockBodega"
		    responseStockD.each do |prodUnidad|
				authorizationEnv = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "POST" + prodUnidad["_id"] + almacenId))
		    	responseEnv = HTTParty.post(url,:body => { :productoId => prodUnidad["_id"], :almacenId => almacenId },:headers => { "Authorization" => "UC "+ user + ":" + authorizationEnv})
		    		
		    	if responseEnv.include?("error")
			    	s["success"] = false
			    else
			    	cantidadMov["cantMov"] += 1
		    	end 
		    		
		    end			    	 
		    

		end

		return s, cantidadMov
				
	end 


end