class Sftp < ActiveRecord::Base
	
	def self.orders
	 chld = 0
	 count = 0
	 fecha = 0
	 rut = 0
     Net::SFTP.start('integra.ing.puc.cl', 'grupo1', :password => 'lsiudhf93') do |sftp|
      data = sftp.download!("/home/grupo1/Pedidos/pedido_525.xml")
      files = sftp.dir.entries("/home/grupo1/Pedidos")
      datas = []
      sftp.dir.entries("/home/grupo1/Pedidos").each do |remote_file|
        file = sftp.file.open("/home/grupo1/Pedidos/"+remote_file.name)
        n_pedido = remote_file.name.split("_")[0]
        
        if count > 4
	        
	    #    begin
	          xml_str = file.read
	          doc = Nokogiri::XML(xml_str)
	          thing = doc.xpath("//Pedido")
	          fecha = doc.xpath("//fecha").map{ |node| node.text.strip }
	          rut = doc.xpath("//rut").map{ |node| node.text.strip }
	          chld = thing.map do |node|
	            node.children.map{ |n| [n.name, n.text.strip] if n.elem? }.compact
	          end.compact
	          if FileOrder.where(:no_roder => n_pedido).first == nil
	          	FileOrder.create(:date => fecha, :no_order => n_pedido)
	          	Order.create()
	          #chld = 1
	     #   rescue
	     #   end
	    end
	    count += 1
	    #begin 
        #  @datas << file.read
        #rescue
        #end
        
      end
      
     end
     return chld, fecha, rut
  	end

  	def self.csv
  		wasGood = exec( "javac -d bin -sourcepath src -cp src/commons-lang-2.6.jar:src/commons-logging-1.1.3.jar:src/jackcess-2.0.2.jar:src/opencsv-2.3.jar src/principal/main.java")
  		wasGood = exec( "java -cp bin:src/commons-lang-2.6.jar:src/commons-logging-1.1.3.jar:src/jackcess-2.0.2.jar:src/opencsv-2.3.jar principal.main" )
  		return wasGood
  	end
end
