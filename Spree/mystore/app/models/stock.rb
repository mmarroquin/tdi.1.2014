class Stock < ActiveRecord::Base
	require 'base64'
  	require 'cgi'
  	require 'openssl'
  	include HTTParty
  	default_params :output => 'json'
  	format :json

  	@@user = "grupo1"
	@@password = "OuyMG5aD"


  	def self.getStock(productos)
		reason = Hash.new
		su = Hash.new
		su[:success] = true
	    
	    depots = getDepots
	    almacenDespacho = depots.find { |almacen| almacen['despacho'] == true }
	    almacenPrincipal = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first
	    almacenEspera = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.last
	    almacenRecepcion = depots.find { |almacen| almacen['recepcion'] == true }

	    almacenPrincipal_id = almacenPrincipal["_id"]
	    almacenPrincipal_espacio = almacenPrincipal["totalSpace"].to_i - almacenPrincipal["usedSpace"].to_i
	    almacenEspera_id = almacenEspera["_id"]
	    almacenEspera_espacio = almacenEspera["totalSpace"].to_i - almacenEspera["usedSpace"].to_i
	    almacenRecepcion_id = almacenRecepcion["_id"]
     

	    responsePrincipal = getSkus(almacenPrincipal_id)  
	    responseRecepcion = getSkus(almacenRecepcion_id)
	    responseEspera = getSkus(almacenEspera_id)


	    espacioPedido = 0
	    productos.each do |prod| 
		    stockPrincipal = 0
		    #stockRecepcion = 0
		    prod[:stockBP] = 0
		    #prod[:stockBR] = 0
		    if responsePrincipal.find { |producto| producto['_id'] == prod[:sku] } #|| responseRecepcion.find { |producto| producto['_id'] == prod[:sku] }

			      if prodActual = responsePrincipal.find { |producto| producto['_id'] == prod[:sku] }
			        stockPrincipal = prodActual["total"]
			        prod[:stockBP] = stockPrincipal
			      end
			      #if prodActual = responseRecepcion.find { |producto| producto['_id'] == prod[:sku] }
			      #	stockRecepcion = prodActual["total"]
			      #	prod[:stockBR] = stockRecepcion

			      #end

			      espacioPedido += prod[:cant].to_i
			      if !prod.include?(:api)
			      others_reserv = Gdoc.return_reservation(prod[:sku], prod[:clienteId])
			  	  end

			      if stockPrincipal < prod[:cant].to_i #stockPrincipal+stockRecepcion
			      	if !prod.include?(:api)
			      		cantPedir = prod[:cant].to_i - stockPrincipal #- stockRecepcion
		    			cantRecibida = pedirDespacho(almacenRecepcion_id, prod[:sku], cantPedir)
		    			movStockSku(almacenRecepcion_id, almacenPrincipal_id, prod[:sku], cantRecibida)
		    			if cantRecibida < cantPedir
		    				su[:success] = false
		    				reason[prod[:sku]] = {:reason => "No existe suficiente stock del producto", :amount_asked => cantPedir, :amount_recieved => cantRecibida }
		    				Rails.logger.warn("No existe suficiente stock del producto " + prod[:sku])
		    			end
		    		else
		    			su[:success] = false
			      		reason[prod[:sku]] = "No existe suficiente stock del producto" 
		    		end
		    	  elsif stockPrincipal-others_reserv.to_i < prod[:cant].to_i #stockPrincipal+stockRecepcion-others_reserv.to_i
		    	  	su[:success] = false
		    	  	reason[prod[:sku]] = "No existe stock disponible debido a reservas"
		    	  	Rails.logger.warn("No existe stock disponible del producto " + prod[:sku] + " debido a reservas")
			      #elsif espacioPedido >  almacenEspera_espacio
			      #	reason[:success] = false 
			      #	reason[:espacio] = "No existe capacidad en la Bodega de Espera"
	
			      end
		      
		    else
		      	if !prod.include?(:api)
		      		cantPedir = prod[:cant].to_i - stockPrincipal #- stockRecepcion
		    		cantRecibida = pedirDespacho(almacenRecepcion_id, prod[:sku], cantPedir)
		    		movStockSku(almacenRecepcion_id, almacenPrincipal_id, prod[:sku], cantRecibida)
		    		if cantRecibida < cantPedir
		    			su[:success] = false
		    			reason[prod[:sku]] = {:reason => "No existe en bodega el producto", :amount_asked => cantPedir, :amount_recieved => cantRecibida }
		    			Rails.logger.warn("No existe en bodega el producto " + prod[:sku])
		    		end
		    	else
		    		su[:success] = false
		      		reason[prod[:sku]] = "No existe en bodega el producto" 
		    	end 
		    end 
		    

		end

		return su,reason
	end	
	
	def self.prepareStock(productos)

		reason = Hash.new
		reason[:success] = true

		depots = getDepots
	    almacenPrincipal_id = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first["_id"]
	    almacenEspera_id = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.last["_id"]

		productos.each do |prod|
			cantidadProd = prod[:cant].to_i
			cantProdPrincipal = 0
			#cantProdRecepcion = 0

			if cantidadProd <= prod[:stockBP]
				cantProdPrincipal = cantidadProd
			else
				cantProdPrincipal = prod[:stockBP]
				#cantProdRecepcion = cantidadProd - cantProdPrincipal
			end

			resultP = movStockSku(almacenPrincipal_id, almacenEspera_id, prod[:sku], cantProdPrincipal)
			#resultR = movStockSku(almacenRecepcion_id, almacenEspera_id, prod[:sku], cantProdRecepcion)
			
			if resultP.include?(:error)
				reason[:success] = false
			    reason[:error] = resultP[:error]
			#elsif resultR.include?(:error)
			#	reason[:success] = false
			#   reason[:error] = resultR[:error]
			end

			if !prod.include?(:api)
				Gdoc.use_reservation(prod[:sku], prod[:clienteId], resultP[:cant_mov])
				#Gdoc.use_reservation(prod[:sku], prod[:clienteId], resultP[:cant_mov] + resultR[:cant_mov])
			end

		end   	
		reason[:resultado] = "El stock esta listo y fue movido a la Bodega de Espera"
		Rails.logger.warn("El stock esta listo y fue movido a la Bodega de Espera")

		return reason
	end  


	def self.pedirDespacho (almacen_id, sku, cantidad)
		
		cantidad_faltante = cantidad
		Rails.logger.warn("Faltan #{cantidad} del producto #{sku}")
		warehouses = []
    	warehouses << Warehouse2_api.new
    	#warehouses << Warehouse3_api.new
    	warehouses << Warehouse4_api.new
    	warehouses << Warehouse5_api.new
    	warehouses << Warehouse6_api.new
    	#warehouses << Warehouse7_api.new
    	warehouses << Warehouse8_api.new
    	warehouses << Warehouse9_api.new

    	warehouses.shuffle!

    	warehouses.each do |wh|
	      	break if cantidad_faltante == 0
	      	Rails.logger.warn("Encargando a Bodega #{wh.class}")
	      	resultado = wh.get_prod(sku, cantidad_faltante, almacen_id)
	      	if resultado >= 0
	      		Rails.logger.warn("Bodega #{wh.class} envio #{resultado}")
		        cantidad_faltante -= resultado
		    else
		        Rails.logger.warn("Bodega #{wh.class} con problemas")
	      	end
    	end

    	# Retorno cuanto se recibió
    	return cantidad - cantidad_faltante

	end

	def self.despachar(productos, direccion, pedidoId)
		reason = Hash.new
		reason[:success] = true

	    depots = getDepots
	    almacenDespacho_id = depots.find { |almacen| almacen['despacho'] == true }["_id"]
	    almacenEspera_id = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.last["_id"]

	    responseEspera = getSkus(almacenEspera_id)	    

	    cantidadesMov = Hash.new
	    cantidadesMov[:total] = 0
	    productos.each do |prod| 

	    	price_prod = Product.last(:select => "products.price", :conditions => ['start_date <= ? AND final_date >= ? AND sku = ?', Date.current, Date.current, prod[:sku] ])
		    if price_prod == nil
		    	price_prod = WebProduct.last(:select => "web_products.price_normal", :conditions => ['sku = ?', prod[:sku] ])
		    	if price_prod ==nil
		    		price_prod = 0
		    	end
		    end
		    cantidadProd = prod[:cant].to_i
		    if responseEspera.find { |producto| producto['_id'] == prod[:sku] }
				url = "http://bodega-integracion-2014.herokuapp.com/stock"
				authorizationStockD = Base64.encode64(OpenSSL::HMAC.digest('sha1', @@password, "GET" + almacenEspera_id + prod[:sku]))
		    	responseStockD = HTTParty.get(url,:query => { :almacenId => almacenEspera_id, :sku => prod[:sku], :limit => cantidadProd },:headers => { "Authorization" => "UC "+ @@user + ":" + authorizationStockD})

		    	prod[:cant_mov] = 0
		    
		    	responseStockD.each do |prodUnidad|
		    		movStockUn(almacenDespacho_id, prodUnidad["_id"])

					authorizationEnv = Base64.encode64(OpenSSL::HMAC.digest('sha1', @@password, "DELETE" + prodUnidad["_id"] + direccion + price_prod + pedido_id))
		    		responseEnv = HTTParty.delete(url,:body => { :productoId => prodUnidad["_id"], :direccion => direccion, :precio => price_prod, :pedidoId => pedido_id },:headers => { "Authorization" => "UC "+ @@user + ":" + authorizationEnv})
		    		
		    		if responseEnv.include?("error")
			    		reason[:success] = false
			    		reason[prodUnidad["_id"]] = responseEnv["error"]
			    		Rails.logger.warn(prodUnidad["_id"] + ": " + responseEnv["error"])
			    	elsif !responseEnv["despachado"]
			    		reason[:success] = false
			    		reason[prodUnidad["_id"]] = "No se pudo despachar el producto"
			    		Rails.logger.warn("No se pudo despachar el producto " + prodUnidad['_id'])
			    	else
			    		prod[:cant_mov] += 1
		    		end 
		    		
		    	end	
		    	cantidadesMov[prod[:sku]] = prod[:cant_mov]		    	
		    	cantidadesMov[:total] += prod[:cant_mov]
		    else
		      	reason[:success] = false
		      	reason[prod[:sku]] = "No existe en bodega de espera el producto" 
		      	Rails.logger.warn("No existe en bodega de espera el producto " + prod[:sku])
		    end 
		    

		end

		return reason, cantidadesMov
				
	end 

	def self.vaciarAlmacenPulmon

		depots = getDepots
		almacenPulmon = depots.find { |almacen| almacen['pulmon'] == true }
		almacenRecepcion = depots.find { |almacen| almacen['recepcion'] == true }
		almacenRecepcion_Espacio = almacenRecepcion["totalSpace"].to_i - almacenRecepcion["usedSpace"].to_i
		if(almacenPulmon["usedSpace"].to_i == 0)
			return 0
		elsif (almacenRecepcion_Espacio == 0)
			return almacenPulmon["usedSpace"].to_i
		else
			#retorna cantidad de productos que quedan en Pulmon
			return almacenPulmon["usedSpace"].to_i - movAllStock(almacenPulmon["_id"], almacenRecepcion["_id"], almacenRecepcion_Espacio)
		end
	end

	#def self.vaciarBodegaRecepcion(sku)
	def self.vaciarAlmacenRecepcion

		depots = getDepots
	    almacenPrincipal = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first
	    almacenRecepcion = depots.find { |almacen| almacen['recepcion'] == true }
	    almacenPrincipal_Espacio = almacenPrincipal["totalSpace"].to_i - almacenPrincipal["usedSpace"].to_i
	    
	    return movAllStock(almacenRecepcion["_id"], almacenPrincipal["_id"], almacenPrincipal_Espacio)
	    #return movStockSku(almacenRecepcion["_id"], almacenPrincipal["_id"], sku, almacenPrincipal["totalSpace"].to_i - almacenPrincipal["usedSpace"].to_i)
	end


	def self.vaciarAlmacenDespacho
		
		depots = getDepots
	    almacenDespacho = depots.find { |almacen| almacen['despacho'] == true }
	    almacenPrincipal = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first
	    almacenPrincipal_Espacio = almacenPrincipal["totalSpace"].to_i - almacenPrincipal["usedSpace"].to_i

		return movAllStock(almacenDespacho["_id"], almacenPrincipal["_id"], almacenPrincipal_Espacio)
		    	  
	end

	def self.movAllStock(origen, destino, limit)
	    response = getSkus(origen)

	    cantidadesMov = 0
	    response.each do |producto|
	    	cantidadesMov += movStockSku(origen, destino, producto["_id"], 0)[:cant_mov]
	    	if cantidadesMov >= limit
	    		break
	    	end
	    end 

		return cantidadesMov 
	end


	def self.movStockSku (origen, destino, sku, limit)
		cantidadesMov = {:sku => sku, :cant_mov => 0 }
	    url = "http://bodega-integracion-2014.herokuapp.com/stock"
		authorizationStock = Base64.encode64(OpenSSL::HMAC.digest('sha1', @@password, "GET" + origen + sku))
		responseStock = HTTParty.get(url,:query => { :almacenId => origen, :sku => sku, :limit => limit},:headers => { "Authorization" => "UC "+ @@user + ":" + authorizationStock})
		
		responseStock.each do |prodUnidad|
			if error = movStockUn(destino, prodUnidad["_id"])
				cantidadesMov[:error] = error
				return cantidadesMov
			end
			cantidadesMov[:cant_mov] += 1
		end	

		return cantidadesMov
	end

	def self.movStockUn (destino, id)
		url = "http://bodega-integracion-2014.herokuapp.com/moveStock"
		authorizationMovi = Base64.encode64(OpenSSL::HMAC.digest('sha1', @@password, "POST" + id + destino))
		responseMovi = HTTParty.post(url,:body => { :productoId => id, :almacenId => destino },:headers => { "Authorization" => "UC "+ @@user + ":" + authorizationMovi})
		    	
		return responseMovi["error"]
	end

	def self.getDepots
		authorization = Base64.encode64(OpenSSL::HMAC.digest('sha1', @@password, "GET"))
	    url = "http://bodega-integracion-2014.herokuapp.com/almacenes"
	    response = HTTParty.get(url,:headers => { "Authorization" => "UC "+ @@user + ":" + authorization})
	end

	def self.getSkus(almacenId)
		url = "http://bodega-integracion-2014.herokuapp.com/skusWithStock"
	    authorization = Base64.encode64(OpenSSL::HMAC.digest('sha1', @@password, "GET" + almacenId))
	    response = HTTParty.get(url,:query => { :almacenId => almacenId },:headers => { "Authorization" => "UC "+ @@user + ":" + authorization})
	end

end