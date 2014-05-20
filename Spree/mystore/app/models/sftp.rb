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
	    	datas << remote_file.name
	          xml_str = file.read
	          doc = Nokogiri::XML(xml_str)
	          thing = doc.xpath("//Pedido")
	          fecha = doc.xpath("//fecha").map{ |node| node.text.strip }
	          rut = doc.xpath("//rut").map{ |node| node.text.strip }
	          chld = thing.map do |node|
	            node.children.map{ |n| [n.name, n.text.strip] if n.elem? }.compact
	          end.compact
	          if not FileOrder.exists?(:no_order => n_pedido) #and false
	         	FileOrder.create(:date => fecha[0], :no_order => n_pedido, :rut => rut[0])
	          	
	      	    chld.each do |ord|
	      	    	sku = ord[0][1]
	      	    	aux = ord
	      	    	quantity = ord[1][1]
	                Order.create(:id_order => n_pedido, :quantity => quantity, :sku_order => sku)
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
     return aux
  	end

  	def self.csv
  		wasGood = exec( "javac -d bin -sourcepath src -cp src/commons-lang-2.6.jar:src/commons-logging-1.1.3.jar:src/jackcess-2.0.2.jar:src/opencsv-2.3.jar src/principal/main.java")
  		wasGood = exec( "java -cp bin:src/commons-lang-2.6.jar:src/commons-logging-1.1.3.jar:src/jackcess-2.0.2.jar:src/opencsv-2.3.jar principal.main" )
  		return wasGood
  	end
end
