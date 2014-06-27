class Request < ActiveRecord::Base
	

	def self.pedirProducto (sku, cant, almacenId)
		cliente_id = ""
		
		aux = [{:sku => sku, :cant => cant, :clienteId => cliente_id, :api => true}]
		respuesta = Stock.getStock(aux)
		if respuesta[0][:success]
			return enviarABodega(almacenId, sku, cant.to_i)
	
		else
			reason = {:success => respuesta[0][:success], :amountSent => 0, :error => "No es posible procesar el pedido. " + respuesta[1][sku]}
			return reason
		end

	end

	def self.enviarABodega(almacenId, sku, cant)
		reason = Hash.new
		reason[:success] = true
		reason[:message] = "Se envio todo"
		reason[:sku] = sku

	    depots = Stock.getDepots
	    almacenDespacho_id = depots.find { |almacen| almacen['despacho'] == true }["_id"]
	    almacenPrincipal_id = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first["_id"]
	  
	  	response1 = Stock.movStockSku(almacenPrincipal_id, almacenDespacho_id, sku, cant, false)
	    response2 = Stock.movStockSku(almacenDespacho_id, almacenId, sku, response1[:cant_mov], true)
	    if response1.include?(:error) || response2.include?(:error) 
	    	reason[:success] = false
	    	if response1.include?(:error)
	    		reason[:message] = "No se pudo enviar todo. " + response1[:error]
	    	else
	    		reason[:message] = "No se pudo enviar todo. " + response2[:error]
	    	end
	    	Stock.movStockSku(almacenDespacho_id, almacenPrincipal_id, sku, cant-response2[:cant_mov])
	    end
	    reason[:amountSent] = response2[:cant_mov]
	    return reason

	end 


end