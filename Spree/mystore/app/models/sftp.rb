class Sftp < ActiveRecord::Base
	
	def self.orders
	 chld = 0
	 count = 0
	 fecha = 0
	 rut = 0
     datas = []
     aux = 0
     Net::SFTP.start('integra.ing.puc.cl', 'grupo1', :password => 'lsiudhf93') do |sftp|
      data = sftp.download!("/home/grupo1/Pedidos/pedido_525.xml")
      files = sftp.dir.entries("/home/grupo1/Pedidos")
      
      sftp.dir.entries("/home/grupo1/Pedidos").each do |remote_file|
        file = sftp.file.open("/home/grupo1/Pedidos/"+remote_file.name)
        begin
        	n_pedido = remote_file.name.split("_")[1].split(".")[0]
        rescue
        end
        if count > 2
	    #    begin
	    	if not FileOrder.exists?(:no_order => n_pedido) #and false
	    	  datas << remote_file.name
	          
	          xml_str = file.read
	          doc = Nokogiri::XML(xml_str)
	          orders = doc.at_xpath("//Pedidos")

    		  fecha = orders.attr("fecha")
              hora = orders.attr("hora")
	          fechaDespacho = orders.at_xpath("fecha").content.strip
	          rut = orders.at_xpath("rut").content.strip
	          direc_id = orders.at_xpath("direccionId").content.strip

	          thing = doc.xpath("//Pedido")
	          chld = thing.map do |node|
	            node.children.map{ |n| [n.name, n.text.strip] if n.elem? }.compact
	          end.compact
	          
	          FileOrder.create(:orderDate => DateTime.parse(fecha + " " + hora), :deliveryDate => fechaDespacho, :no_order => n_pedido, :rut => rut, :direcc_id =>direc_id, :processed => false, :delivered => false)
	          	
	      	  chld.each do |ord|
	      	    sku = ord[0][1]
	      	    aux = ord
	      	    quantity = ord[1][1]
	            Order.create(:id_order => n_pedido, :quantity => quantity, :sku_order => sku, :delivered => false)
	          end
	        end
	          #chld = 1
	     #   rescue
	      
	    end
	    count += 1
	    #end
	    
	    #begin 
        #  @datas << file.read
        #rescue
        #end
        
      end
      
     end
     
  	end

  	def self.csv
		aux = Dir.pwd
		#wasGood = exec( "cd /home/administrator")

  		#wasGood = exec( "javac -d bin -sourcepath src -cp /home/administrator/commandsapp/src/commons-lang-2.6.jar:/home/administrator/commandsapp/src/commons-logging-1.1.3.jar:/home/administrator/commandsapp/src/jackcess-2.0.2.jar:/home/administrator/commandsapp/src/opencsv-2.3.jar /home/administrator/commandsapp/llamarRuby/src/principal/main.java")
  		wasGood = exec( "java -cp bin:/home/administrator/commandsapp/src/commons-lang-2.6.jar:/home/administrator/commandsapp/src/commons-logging-1.1.3.jar:/home/administrator/commandsapp/src/jackcess-2.0.2.jar:/home/administrator/commandsapp/src/opencsv-2.3.jar principal.main" )
  		return wasGood
  	end
end
