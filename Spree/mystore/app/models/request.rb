class Request < ActiveRecord::Base
	

	def self.pedirProducto (almacenId, sku, cant)
		cliente_id = ""
		
		aux = [{:sku => sku, :cant => cant, :clienteId => cliente_id, :api => true}]
		respuesta = Stock.getStock(aux)
		if respuesta[:success]
			return enviarABodega(almacenId, sku, cant.to_i)
	
		else
			reason = {:success => respuesta[:success], :amountSent => 0, :error => "No es posible procesar el pedido"}
			return reason
		end

	end

	def self.enviarABodega(almacenId, sku, cant)
		reason = Hash.new
		reason[:success] = true
		reason[:message] = "Se envió todo"
		reason[:sku] = sku

	    depots = Stock.getDepots
	    
	    almacenPrincipal_id = depots.first { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}["_id"]
	    almacenEspera_id = depots.last { |almacen| almacen['despacho'] == false &&  almacen['recepcion'] == false && almacen['pulmon'] == false}["_id"]
	    response = Stock.movStockSku(almacenEspera_id, almacenId, sku, cant)
	    if response.include?(:error)
	    	reason[:success] = false
	    	reason[:message] = "No se pudo enviar todo"
	    	Stock.movStockSku(almacenEspera_id, almacenPrincipal_id, sku, cant-response[:cant_mov])
	    end
	    reason[:amountSent] = response[:cant_mov]
	    return reason

	end 


end