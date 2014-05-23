class Schedule < ActiveRecord::Base
	require 'rest_client'
	require 'uri'
	require 'json'

	def self.main
		
		Sftp.orders
		
		#Ejecutar precios una vez a la semana
		#Sftp.csv
		
		#Esteban retorna true y queda listo
		#@ordenes = Order.all
		#producto = []
		#@ordenes.each do |orden|
		#	p = FileOrder.where(:no_order => orden.id_order).first()
		#	producto << {:sku => orden.sku_order, :cant => orden.quantity, :clienteId => p.rut}
		#end

		#if Stock.getStock(producto)
		#	direccion = Schedule.crm(p.rut, p.direcc_id)
		#	Product.readcsv

		#	despacho  = Stock.despachar(producto, direccion, p.no_order)

		#	Report.create(:n_pedido =>p.no_order, :despachado =>despacho, :fecha =>  p.date)
		#end
		

		#Order.id_order = FileOrder.no_order
		@archivos = FileOrder.all
		@archivos.each do |file|
			producto = []
			despacho = false
			hay_stock = false
			@orders = Order.where(:id_order => file.no_order)
			@orders.each do |orden|
				producto << {:sku => orden.sku_order, :cant => orden.quantity, :clienteId => file.rut}
			end
			if producto.length > 0
				hay_stock = Stock.getStock(producto)

				if hay_stock
					direccion = Schedule.crm(file.rut, file.direcc_id)
					despacho = Stock.despachar(producto, direccion, file.no_order)
				end
			end

			Report.create(:n_pedido => file.no_order, :despachado => despacho, :quiebre => hay_stock, :fecha => file.no_order)
		end
		


		#return Stock.getStock(producto)
		#producto =  [{:sku = "302393", :cant = "15", :clienteId = "17356486-4"}, {:sku = "354342", :cant = "20", :clienteId = "13645768-5"}]
		#Pregunto vale precio
		#pregunto esteban1 direccion
		#Despacho a esteban2
	end

	def self.crm(rut, direc)
		@rut_empresa=rut
  		@input_id=direc

  	#Aca definimos los parametros para acceder a la API

	    # @r guarda la informacion del login.
	  	@r=""
	  	#usuario...
	  	@user='grupo1'
	  	#URL's del webservice
	  	@wsurl='http://integra.ing.puc.cl/vtigerCRM/webservice.php?operation='
	  	@endpointUrl='http://integra.ing.puc.cl/vtigerCRM/webservice.php?'
  	

	#Aca se hace el login (challenge y login)
		#definimos url wb challenge
	  	get_challenge_url = @wsurl+'getchallenge&username='+@user
	  	#hacemos un GET con el usuario
	  	challenge =RestClient.get get_challenge_url
	  	#obtenemos el token
	  	@token=JSON.parse(challenge.body)['result']['token']
	  	#definimos url login
	  	path_login =@wsurl+'login'
	  	#transformamos los datos
	  	@md5 = Digest::MD5.hexdigest(@token+'Cyz9KPyu0sNNknpm')
	  	#hacemos el post
	  	login=RestClient.post path_login,
	  	'operation' => 'login',
	  	'username' =>@user,
	  	'accessKey'=>@md5
	  	#obtenemos la informacion
	  	@p=JSON.parse(login.body)['result']
	  	if(@p==nil or @p['success']==false)
	  		#El caso de que no se pudo realizar el login...
	  		@r="NO"
	  		@message="Sesion ID: "+"-"+". Login aceptado: "+@r
	  	
	  	else
	  		#El caso de que se realizo el login...
	  		@r="YES"
		  	@message="Sesion ID: "+JSON.parse(login.body)['result']['sessionName']+". Login aceptado: "+@r
		  	
		end
	##
	#@query="select * from Contacts where lastname='Bautista' and firstname='Emilio';"
	


	#Aca ya se tiene una conexion a vTiger y se procede a obtener la empresa con el rut del input.

		#Se define la query a la tabla de empresas (accounts).
		@query="select * from Accounts where cf_705='"+@rut_empresa+"';"
	    @queryParam = URI::encode(@query)
	    @sessionId=JSON.parse(login.body)['result']['sessionName']
		#use sessionId created at the time of login.
		@params = 'sessionName='+@sessionId+'&operation=query&query='+@queryParam
		#describe request must be GET request.
		
		path_query = @endpointUrl+@params
		resultado =RestClient.get path_query

		@id_empresa=JSON.parse(resultado.body)['result'][0]['id']
		@b0=resultado.body
		@nombre_empresa=JSON.parse(resultado.body)['result'][0]['accountname']
		@telefono_empresa=JSON.parse(resultado.body)['result'][0]['phone']
		@billing_street_empresa=JSON.parse(resultado.body)['result'][0]['bill_street']
		@billing_state_empresa=JSON.parse(resultado.body)['result'][0]['bill_city']
		@billing_city_empresa=JSON.parse(resultado.body)['result'][0]['bill_state']
		
		#decode the json encode response from the server.

	    @message=@message+"...."+resultado+"..."+@sessionId+"/n/n/n/n"





	#Aca se procede a obtener la direccion del empleado de la empresa obtenida
		#Se define el query para obtener el empleado correspondiente
		@query="select * from Contacts where account_id="+@id_empresa+" and cf_707='"+@input_id+"';"
	    @queryParam = URI::encode(@query)
	    @sessionId=JSON.parse(login.body)['result']['sessionName']
	    @b1=login.body
		#use sessionId created at the time of login.
		@params = 'sessionName='+@sessionId+'&operation=query&query='+@queryParam
		#describe request must be GET request.
		
		
		path_query2 = @endpointUrl+@params
		resultado2 =RestClient.get path_query2
		@id_empresa=JSON.parse(resultado2.body)['result'][0]['otherstreet']
		#decode the json encode response from the server.
		@b2=resultado2.body
		@nombre_empleado=JSON.parse(resultado2.body)['result'][0]['firstname']
		@apellido_empleado=JSON.parse(resultado2.body)['result'][0]['lastname']
		@telefono_empleado=JSON.parse(resultado2.body)['result'][0]['phone']
		@account_id_empleado=JSON.parse(resultado2.body)['result'][0]['account_id']
		@empleado_street=JSON.parse(resultado2.body)['result'][0]['otherstreet']
		@comuna_empleado=JSON.parse(resultado2.body)['result'][0]['othercity']
		@region_empleado=JSON.parse(resultado2.body)['result'][0]['otherstate']
		@message2="..."+resultado2+"..."+@sessionId




		@resultado = @empleado_street +","+ @comuna_empleado +","+ @region_empleado



		return @resultado

	end
end
