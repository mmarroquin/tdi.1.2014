class Request < ActiveRecord::Base
	

	def self.pedirProducto (usuario, password, almacenId, sku, cant)
		aux = [{:sku => sku, :cant => cant, :reserv => "0", :api => true}]
		respuesta = Stock.getStock(aux)
		if respuesta[:success]
			return enviarBodega(aux, almacenId)
		end

	end

	def self.enviarBodega(productos, almacenId)
		s["success"] = true
		reason = Hash.new
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
			    	reason["error"] = responseEnv["error"]
			    else
			    	cantidadMov["cantMov"] += 1
		    	end 
		    		
		    end			    	 
		    

		end

		return s, cantidadMov, reason
				
	end 


end