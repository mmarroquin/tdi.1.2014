class Dashboard < ActiveRecord::Base
	require 'googlecharts'

	def self.plot
		grafico = Gchart.pie_3d(:title => "Joseto el mejors",
			:labels => ["Despachado", "Quebrado", "Pulentoso"],
			:data => [10,30,100],
			:size => '400x200')
		return grafico
	end

#	def self.info
#		grafico = Gchart.pie_3d(:title => "Fancy title",
#			:labels => ["Fancy entry", "Fancy entry2", "Whatever"],
#			:data => [200,350,100],
#			:size => '400x200')
#		return grafico
#	end

	def self.plot_reservations
		total_date = Reservation.count
		today = Date.current
		now = Reservation.where(date: today).count
		yest = Reservation.where(date: today-1.days).count
		dayb = Reservation.where(date: today-2.days).count
		daybb = Reservation.where(date: today-3.days).count
		daybbb = Reservation.where(date: today-4.days).count
		daybbbb = Reservation.where(date: today-5.days).count
		daybbbbb = Reservation.where(date: today-6.days).count


		grafico = Gchart.bar(:title => "Reservations per day in the week",
			:labels => [today,today-1.days,today-2.days,today-3.days,today-4.days,today-5.days,today-6.days],
			:data => [now, yest, dayb, daybb, daybbb, daybbbb, daybbbbb])
		return grafico
	end	

	def self.plot_porcentaje_de_prods_online
		total_prods = Product.count
		total_online = WebProduct.count
		dif = total_prods - total_online

		if total_prods != 0 and total_online != 0
			grafico = Gchart.pie_3d(:title => "Porcentaje de productos publicados online vs no disponibles online",
				:labels => ["Disponible online", "No disponible desde la web"],
				:data => [total_online,dif],
				:size => '600x200')
			return grafico
		else
			return "La BD de productos o la BD de WebProductos esta vacia"
		end
	end

	def self.plot_porcentaje_de_despachos_quebrados
		total_quebrados = Order.where(:broked => true).count
		total_despachados = Order.where(:broked => false, :delivered => true)

		if total_prods != 0 and total_despachados != 0
			grafico = Gchart.pie_3d(:title => "Porcentaje de despachos efectivos vs quebrados",
				:labels => ["Despachos efectivos", "Despachos quebrados"],
				:data => [total_despachados,total_quebrados],
				:size => '600x200')
			return grafico
		else
			return "La BD de Reportes esta vacia"
		end
	end

	def self.plot_porcentaje_despachos_suplidos_pedidos_quebrados
		return 0
	end

	def self.plot_ofertas
		total = 0
		Offer.all.each do |o|
			sku = o.sku
			arreglo = Order.find_all_by_sku_order(sku)
			if arreglo.count > 0
				encontrado = false
				if (not encontrado)
					arreglo.each do |a|
						id = a.id_order
						orden = FileOrder.find_all_by_no_order(id)
						if orden.count > 0
							orden.each do |b|
								if b.orderDate > o.inicio and b.orderDate < o.fin and (not encontrado)
									total = total+1
									encontrado = true
								end
							end
						end
					end
				end
			end
		end

		total_ofertas = Offer.count
		dif = total_ofertas - total
		grafico = Gchart.pie_3d(:title => "Porcentaje de ofertas exitosas",
				:labels => ["Ofertas sin ventas", "Ofertas con ventas"],
				:data => [dif,total],
				:size => '600x200')
		return grafico
	end

	def self.plot_histograma_atrasos_ultimo_mes
		contador = [0,0,0,0,0,0,0]
		i = 0
		while i < 30
			atraso = BD.atrasados.where(date: today-i)
			atraso.each do |a|
				if atraso < 10
					contador[0] = contador[0]+1
				elsif atraso < 30
					contador[1] = contador[1]+1
				elsif atraso < 60
					contador[2] = contador[2]+1
				elsif atraso < 60*6
					contador[3] = contador[3]+1
				elsif atraso < 60*12
					contador[4] = contador[4]+1
				elsif atraso < 60*24
					contador[5] = contador[5]+1
				else
					contador[6] = contador[6]+1
				end
			end
		end


		grafico = Gchart.bar(:title => "Histograma de atrasos",
			:labels => ["0-10","10-30","30-60","1h-6h","6h-12h","12h-24h","1dia+"],
			:data => contador)
		return grafico
	end

	def self.plot_cantidad_d_prods_por_tipo
		a = []
		b = []
		Order.all.each do |o|
			sku = o.sku_order
			p = WebProduct.find_by_sku(sku)
			if p
				if not a.include?(p.category.split(',')[0])
					a << p.category.split(',')[0]
					b << 1
				else
					i = 0
					while i < a.count
						if a[i] == p.category.split(',')[0]
							b[i] = b[i] +1
						end
						i = i+1
					end
				end
			end
		end

		aux_a = []
		aux_b = []

		i = 0
		iteraciones = 5
		while i < iteraciones do
			if i < iteraciones -1
				index = 0
				index = b.index(b.max)
				if index
					aux_a << a[index]
					aux_b << [b[index]]

					a.delete_at(index)
					b.delete_at(index)
				end
			else
				aux_a << "Otros"
				aux_b << b.inject{|sum, x| sum + x}
			end

			i = i +1
				
		end


		grafico = Gchart.bar(:title => "Top categorias de ventas",
			:legend => aux_a[0..aux_a.count-2],
			:data => aux_b[0..aux_b.count-2],
			:stacked => false,
			:bar_colors => ["FF0000,FFFF00,00FF00,0000FF"],
			:axis_with_labels => ['y'],
			:axis_labels => [[100,200,300,400,500,600,700]],
			:alignment => :center,
			:size => '600x200')
		
		return grafico
	end

#	def self.plot_bar
#		grafico = Gchart.bar( :data => [[1,2,4,67,100,41,234],[45,23,67,12,67,300, 250]], 
 #           :title => 'SD Ruby Fu level', 
  #          :legend => ['matt','patrick'],  
   #         :bar_colors => 'ff0000,00ff00',
    #        :size => '400x200')
	#	return grafico
	#end

#	def self.plot_radar
#		grafico = Gchart.radar(:data => [1,2,4,67,100,41,234], :curved => true)
#		return grafico
#	end

#	def self.plot_line
#		grafico = Gchart.line( :data => [17, 17, 11, 8, 2], 
 #             :axis_with_labels => ['x', 'y'], 
  #            :axis_labels => [['J', 'F', 'M', 'A', 'M']], 
   #           :axis_range => [nil, [2,17,5]])
	#	return grafico
	#end
end
