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
	    almacenPrincipal_id = depots.select { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}.first["_id"]
	  
	    response = Stock.movStockSku(almacenPrincipal_id, almacenId, sku, cant)
	    if response.include?(:error)
	    	reason[:success] = false
	    	reason[:message] = "No se pudo enviar todo. " + response[:error]
	    	#Stock.movStockSku(almacenEspera_id, almacenPrincipal_id, sku, cant-response[:cant_mov])
	    end
	    reason[:amountSent] = response[:cant_mov]
	    return reason

	end 


end