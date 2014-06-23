class Schedule < ActiveRecord::Base
	

	def self.main
		
		@ordenesAProcesar = FileOrder.where(:processed => false)
		@ordenesAProcesar.each do |file|
			producto = []
			totalQuantity = 0
			#despacho = false
			hay_stock = false
			@orders = Order.where(:id_order => file.no_order)
			@orders.each do |orden|
				producto << {:sku => orden.sku_order, :cant => orden.quantity, :clienteId => file.rut}
				totalQuantity += orden.quantity
			end
			if producto.length > 0
				hay_stock = Stock.getStock(producto)[:success]

				if hay_stock
					Stock.prepareStock(producto)
					#despacho[0] = Stock.despachar(producto, direccion, file.no_order)
				end
				direccion = Crm.crm(file.rut, file.direcc_id)
				FileOrder.update(:processed => true, :success => hay_stock)
				DataWarehouse::FileOrder.create(client_id: file.rut, order_id: file.no_order, address: direccion, quantity: totalQuantity, success: hay_stock, deliveryDate: file.deliveryDate, orderDate: file.orderDate)
			end

			#Report.create(:n_pedido => file.no_order, :despachado => despacho, :quiebre => hay_stock, :fecha => file.no_order)
		end
	end

	def self.delivery
		@ordenesADespachar = FileOrder.all(:conditions => ['deliveryDate <= ? AND processed = ? AND success = ? AND delivered = ?', Date.current, true, true, false])
		#FileOrder.where(:processed => true, :success => true, :delivered => false, :deliveryDate )
		@ordenesADespachar.each do |file|
			producto = []
			@orders = Order.where(:id_order => file.no_order, :delivered => false)
			@orders.each do |orden|
				producto << {:sku => orden.sku_order, :cant => orden.quantity, :clienteId => file.rut}
			end
			if producto.length > 0
				direccion = Crm.crm(file.rut, file.direcc_id)
				response = Stock.despachar(producto, direccion, file.no_order)
				DataWarehouse::DeliveryOrder.create(client_id: file.rut, order_id: file.no_order, address: direccion, quantitySent: response[1][:total] , deliveryDate: Date.current)
				@orders.each do |orden|
					if !response[1].include?(orden.sku_order)
						orden.delivered = true
					end
				end
			else
				FileOrder.update(:delivered => true)
			end	
		end
	end

	def self.new_orders
		#Revisar nuevos pedidos desde FTP - Ingresar nuevos pedidos
		Sftp.orders
	end

	def self.new_reservations
		#Revisar nuevas reservas desde Google Spreadsheet - Ingresar/Actualizar nuevas reservas
		Gdoc.obtain_info
	end

	def self.new_pricing
		#Revisar nuevos precios desde Access - Ingresar/Actualizar nuevos precios
		Product.readcsv
	end

	def self.new_product
		#Revisar nuevos productos desde archivo Json - Ingresar/Actualizar nuevos productos
		WebProduct.read
	end
end
