class Stock < ActiveRecord::Base
	require 'base64'
  	require 'cgi'
  	require 'openssl'
  	include HTTParty
  	default_params :output => 'json'
  	format :json

  	def self.getStock (productos)
		success = true
		reason = Hash.new
	    user = "grupo1"
	    password = "OuyMG5aD"
	    authorization = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET"))
	    url = "http://bodega-integracion-2014.herokuapp.com/almacenes"
	    response = HTTParty.get(url,:headers => { "Authorization" => "UC "+ user + ":" + authorization})


	    almacenDespacho = response.find { |almacen| almacen['despacho'] == true }
	    almacenPrincipal = response.find { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false && almacen["totalSpace"].to_i > 20000}
	    almacenRecepcion = response.find { |almacen| almacen['recepcion'] == true }

	    almacenPrincipal_id = almacenPrincipal["_id"]
	    almacenPrincipal_espacio = almacenPrincipal["totalSpace"].to_i - almacenPrincipal["usedSpace"].to_i
	    almacenDespacho_id = almacenDespacho["_id"]
	    almacenDespacho_espacio = almacenDespacho["totalSpace"].to_i - almacenDespacho["usedSpace"].to_i
	    almacenRecepcion_id = almacenRecepcion["_id"]
      
    
	    url = "http://bodega-integracion-2014.herokuapp.com/skusWithStock"
	    authorizationPrincipal = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenPrincipal_id))
	    authorizationRecepcion = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenRecepcion_id))
	    responsePrincipal = HTTParty.get(url,:query => { :almacenId => almacenPrincipal_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationPrincipal})
	    responseRecepcion = HTTParty.get(url,:query => { :almacenId => almacenRecepcion_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationRecepcion})
	    
	    authorizationB = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenDespacho_id))
	    responseB = HTTParty.get(url,:query => { :almacenId => almacenDespacho_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationB})

	    espacioPedido = 0
	    productos.each do |prod| 
		    stockPrincipal = 0
		    stockRecepcion = 0
		    prod[:stockBP] = 0
		    prod[:stockBR] = 0
		    if responsePrincipal.find { |producto| producto['_id'] == prod[:sku] } || responseRecepcion.find { |producto| producto['_id'] == prod[:sku] }

			      if prodActual = responsePrincipal.find { |producto| producto['_id'] == prod[:sku] }
			        stockPrincipal = prodActual["total"]
			        prod[:stockBP] = stockPrincipal
			      end
			      if prodActual = responseRecepcion.find { |producto| producto['_id'] == prod[:sku] }
			      	stockRecepcion = prodActual["total"]
			      	prod[:stockBR] = stockRecepcion
			      end

			      espacioPedido += prod[:cant].to_i

			      if stockPrincipal+stockRecepcion < prod[:cant].to_i
			      	success = false
			      	reason[prod[:sku]] = "No existe suficiente stock del producto"
			      	cantPedir = prod[:cant].to_i - stockPrincipal - stockRecepcion
		    		pedirDespacho(user, almacenRecepcion_id, prod[:sku], cantPedir)
		    	  elsif stockPrincipal+stockRecepcion-prod[:reserv].to_i < prod[:cant].to_i
		    	  	success = false
		    	  	reason[prod[:sku]] = "No existe stock disponible debido a reservas"
			      elsif espacioPedido >  almacenDespacho_espacio
			      	success = false 
			      	reason["espacio"] = "No existe capacidad en la bodega de despacho"
	
			      end
		      
		    else
		      	success = false
		      	reason[prod[:sku]] = "No existe en bodega el producto" 
		      	cantPedir = prod[:cant].to_i
		    	pedirDespacho(user, almacenRecepcion_id, prod[:sku], cantPedir)  
		    end 
		    

		end

		if !success
			return success, reason
		end
		
		productos.each do |prod|
			cantidadProd = prod[:cant].to_i
			cantProdPrincipal = 0
			cantProdRecepcion = 0

			if cantidadProd <= prod[:stockBP]
				cantProdPrincipal = cantidadProd
			else
				cantProdPrincipal = prod[:stockBP]
				cantProdRecepcion = cantidadProd - cantProdPrincipal
			end

			url = "http://bodega-integracion-2014.herokuapp.com/stock"
			authorizationStockP = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenPrincipal_id + prod[:sku]))
		    responseStockP = HTTParty.get(url,:query => { :almacenId => almacenPrincipal_id, :sku => prod[:sku], :limit => cantProdPrincipal },:headers => { "Authorization" => "UC "+ user + ":" + authorizationStockP})
		    authorizationStockR = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenRecepcion_id + prod[:sku]))
		    responseStockR = HTTParty.get(url,:query => { :almacenId => almacenRecepcion_id, :sku => prod[:sku], :limit => cantProdRecepcion },:headers => { "Authorization" => "UC "+ user + ":" + authorizationStockR})

		    url = "http://bodega-integracion-2014.herokuapp.com/moveStock"
		    responseStockP.each do |prodUnidad|
				
				authorizationMovi = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "POST" + prodUnidad["_id"] + almacenDespacho_id))
		    	responseMovi = HTTParty.post(url,:body => { :productoId => prodUnidad["_id"], :almacenId => almacenDespacho_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationMovi})
		    	if responseMovi.include?("error")
			    	success = false
			    	reason["error"] = responseMovi["error"]
			    	return success, reason
		    	end 
		    end	

		    		    
		    responseStockR.each do |prodUnidad|
				
				authorizationMovi = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "POST" + prodUnidad["_id"] + almacenDespacho_id))
		    	responseMovi = HTTParty.post(url,:body => { :productoId => prodUnidad["_id"], :almacenId => almacenDespacho_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationMovi})
		  		if responseMovi.include?("error")
			    	success = false
			    	reason["error"] = responseMovi["error"]
			    	return success, reason
		    	end   
		    end	

		end   	
		reason["resultado"] = "Existe stock y este fue movido a la Bodega de Despacho"
		return success, reason
	end  


	def self.pedirDespacho (user, almacen_id, sku, cantidad)

		password = "grupo1"
		encryptedPassword = Digest::SHA1.hexdigest(password)

		url =  "http://integra5.ing.puc.cl/api/v1/pedirProducto"
		response = HTTParty.post(url,:body => { :usuario => user, :password => encryptedPassword, :almacenId => almacen_id, :sku => sku, :cantidad => cantidad })
		return response
		if !response.include?("error")
			return response
		
		else		
			url =  "http://integra4.ing.puc.cl/api/pedirProducto"
			response = HTTParty.post(url,:body => { :usuario => user, :password => encryptedPassword, :almacenId => almacen_id, :sku => sku, :cantidad => cantidad })
			if !response.include?("error")
				return response
			else
				return response["error"]
			end
		end
	
	end



	def self.vaciarBodegaRecepcion

		success = true
		reason = ""
		user = "grupo1"
	    password = "OuyMG5aD"
	    authorization = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET"))
	    url = "http://bodega-integracion-2014.herokuapp.com/almacenes"
	    response = HTTParty.get(url,:headers => { "Authorization" => "UC "+ user + ":" + authorization})
	    
	    almacenPrincipal = response.find { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false && almacen["totalSpace"].to_i > 2000}
	    almacenRecepcion = response.find { |almacen| almacen['recepcion'] == true }

	    almacenPrincipal_id = almacenPrincipal["_id"]
	    almacenRecepcion_id = almacenRecepcion["_id"]

		url = "http://bodega-integracion-2014.herokuapp.com/skusWithStock"
		authorizationR = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenRecepcion_id))
	    responseR = HTTParty.get(url,:query => { :almacenId => almacenRecepcion_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationR})

	    cantidadesMov = Hash.new
	    responseR.each do |producto|
	    	url = "http://bodega-integracion-2014.herokuapp.com/stock"
			authorizationStockR = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenRecepcion_id + producto["_id"]))
		    responseStockR = HTTParty.get(url,:query => { :almacenId => almacenRecepcion_id, :sku => producto["_id"] },:headers => { "Authorization" => "UC "+ user + ":" + authorizationStockR})
		    
		    producto["cant_mov"] = 0
		    url = "http://bodega-integracion-2014.herokuapp.com/moveStock"

		    responseStockR.each do |prodUnidad|
				authorizationMovi = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "POST" + prodUnidad["_id"] + almacenPrincipal_id))
		    	responseMovi = HTTParty.post(url,:body => { :productoId => prodUnidad["_id"], :almacenId => almacenPrincipal_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationMovi})
		    	if responseMovi.include?("error")
			    	success = false
			    	reason = responseMovi["error"]
			    	cantidadesMov[producto["_id"]] = producto["cant_mov"]
			    	return success, reason, cantidadesMov
		    	end  
		    	producto["cant_mov"] += 1
		    end	
		    cantidadesMov[producto["_id"]] = producto["cant_mov"]

		end 

		return success, cantidadesMov

	end


	def self.vaciarBodegaDespacho

		success = true
		reason = ""
		user = "grupo1"
	    password = "OuyMG5aD"
	    authorization = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET"))
	    url = "http://bodega-integracion-2014.herokuapp.com/almacenes"
	    response = HTTParty.get(url,:headers => { "Authorization" => "UC "+ user + ":" + authorization})
	    
	    almacenDespacho = response.find { |almacen| almacen['despacho'] == true }
	    almacenPrincipal = response.find { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false && almacen["totalSpace"].to_i > 200}
	    almacenRecepcion = response.find { |almacen| almacen['recepcion'] == true }

	    almacenPrincipal_id = almacenPrincipal["_id"]
	    almacenDespacho_id = almacenDespacho["_id"]

		url = "http://bodega-integracion-2014.herokuapp.com/skusWithStock"
		authorizationB = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenDespacho_id))
	    responseB = HTTParty.get(url,:query => { :almacenId => almacenDespacho_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationB})

	    cantidadesMov = Hash.new
	    responseB.each do |producto|
	    	url = "http://bodega-integracion-2014.herokuapp.com/stock"
			authorizationStockB = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "GET" + almacenDespacho_id + producto["_id"]))
		    responseStockB = HTTParty.get(url,:query => { :almacenId => almacenDespacho_id, :sku => producto["_id"] },:headers => { "Authorization" => "UC "+ user + ":" + authorizationStockB})

		    producto["cant_mov"] = 0
		    url = "http://bodega-integracion-2014.herokuapp.com/moveStock"
		    
		    responseStockB.each do |prodUnidad|
				authorizationMovi = Base64.encode64(OpenSSL::HMAC.digest('sha1', password, "POST" + prodUnidad["_id"] + almacenPrincipal_id))
		    	responseMovi = HTTParty.post(url,:body => { :productoId => prodUnidad["_id"], :almacenId => almacenPrincipal_id },:headers => { "Authorization" => "UC "+ user + ":" + authorizationMovi})
		    	
		    	if responseMovi.include?("error")
			    	success = false
			    	reason = responseMovi["error"]
			    	cantidadesMov[producto["_id"]] = producto["cant_mov"]
			    	return success, reason, cantidadesMov
		    	end 
		    	producto["cant_mov"] += 1
		    end	
		    cantidadesMov[producto["_id"]] = producto["cant_mov"]

		end 

		return success, cantidadesMov   
	end

end