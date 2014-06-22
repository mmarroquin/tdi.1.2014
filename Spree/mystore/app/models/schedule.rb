class Schedule < ActiveRecord::Base
	

	def self.main
		
		@archivos = FileOrder.where(:processed => false)
		@archivos.each do |file|
			producto = []
			despacho = false
			hay_stock = false
			@orders = Order.where(:id_order => file.no_order)
			@orders.each do |orden|
				producto << {:sku => orden.sku_order, :cant => orden.quantity, :clienteId => file.rut}
			end
			if producto.length > 0
				hay_stock = Stock.getStock(producto)[:success]

				if hay_stock
					direccion = Crm.crm(file.rut, file.direcc_id)
					despacho[0] = Stock.despachar(producto, direccion, file.no_order)
				end
			end

			Report.create(:n_pedido => file.no_order, :despachado => despacho, :quiebre => hay_stock, :fecha => file.no_order)
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
