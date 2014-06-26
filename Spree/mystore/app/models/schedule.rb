class Schedule < ActiveRecord::Base
	

	def self.main
		begin
		@ordenesAProcesar = FileOrder.where(:processed => false)
		@ordenesAProcesar.each do |file|
			producto = []
			totalQuantity = 0
			#despacho = false
			hay_stock = false
			@orders = Order.where(:id_order => file.no_order)
			@orders.each do |orden|
				producto << {:sku => orden.sku_order, :cant => orden.quantity.to_i, :clienteId => file.rut}
				#totalQuantity += orden.quantity.to_i
			end
			if producto.length > 0
				response = Stock.getStock(producto)
				hay_stock = response[0][:success]
				direccion = Crm.crm(file.rut, file.direcc_id)
				file.update(:processed => true, :success => hay_stock)
				
				if !hay_stock
					response[1].each do |key,value|
					producto.delete_if { |prod| prod[:sku] == key }
					@orders.update_all({:broked => true}, ['sku_order = ?', key])
					DataWarehouse::BrokenProduct.create(client_id: file.rut, order_id: file.no_order, sku: key, address: direccion, reason: value , deliveryDate: Date.current)
					end
					#despacho[0] = Stock.despachar(producto, direccion, file.no_order)
				end
				Stock.prepareStock(producto)
				producto.each do |prod|
					totalQuantity += prod[:cant]
				end
				DataWarehouse::FileOrder.create(client_id: file.rut, order_id: file.no_order, address: direccion, quantity: totalQuantity, success: hay_stock, deliveryDate: file.deliveryDate, orderDate: file.orderDate)
			end

			#Report.create(:n_pedido => file.no_order, :despachado => despacho, :quiebre => hay_stock, :fecha => file.no_order)
		end
		return "Proceso de pedidos correcto"
		rescue
			return "Error en el metodo"
		end
	end

	def self.prueba

		a = DataWarehouse::DeliveredProduct.create(cliente_id: "5920406-8")
		puts a
	end

	def self.delivery
		begin
		@ordenesADespachar = FileOrder.all(:conditions => ['processed = ? AND dilevered = ? AND deliveryDate <= ?', true, false, Date.current])
		#FileOrder.where(:processed => true, :success => true, :delivered => false, :deliveryDate )
		@ordenesADespachar.each do |file|
			producto = []
			@orders = Order.where(:id_order => file.no_order, :broked => false, :delivered => false)
			if @orders != nil
 				@orders.each do |orden|
					producto << {:sku => orden.sku_order, :cant => orden.quantity, :clienteId => file.rut}
				end
				if producto.length > 0
					direccion = Crm.crm(file.rut, file.direcc_id)
					response = Stock.despachar(producto, direccion, file.no_order)
					@orders.each do |orden|
						if !response[1].include?(orden.sku_order)
							orden.delivered = true
							DataWarehouse::DeliveredProduct.create(client_id: file.rut, order_id: file.no_order, sku: orden.sku_order, address: direccion, quantitySent: response[1][:total] , deliveryDate: Date.current)
							Report.create(:n_pedido => file.no_order, :despachado => orden.delivered)
						end
					end
				end	
			else
				FileOrder.update(:delivered => true)
			end
		end
		return "Delivery correcto"
		rescue
			return "Error en el metodo"
		end
	end

	def self.new_orders
		#Revisar nuevos pedidos desde FTP - Ingresar nuevos pedidos
		return Sftp.orders + ", Revision correcta"
		
	end

	def self.new_reservations
		#Revisar nuevas reservas desde Google Spreadsheet - Ingresar/Actualizar nuevas reservas
		begin
		Gdoc.obtain_info
		return "Revision correcta"
		rescue
			return "Error en el metodo"
		end
	end

	def self.new_pricing
		#Revisar nuevos precios desde Access - Ingresar/Actualizar nuevos precios
		begin
		Product.readcsv
		return "Revision correcta"
		rescue
			return "Error en el metodo"
		end
	end

	def self.new_product
		#Revisar nuevos productos desde archivo Json - Ingresar/Actualizar nuevos productos
		begin
		WebProduct.read
		return "Revision correcta"
		rescue
			return "Error en el metodo"
		end
	end

	def self.reset
		new_product
		new_pricing
		new_reservations
		new_orders
	end
end
