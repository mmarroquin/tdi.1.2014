class Sftp < ActiveRecord::Base
	def self.archivos
     Net::SFTP.start('integra.ing.puc.cl', 'grupo1', :password => 'lsiudhf93') do |sftp|
      data = sftp.download!("/home/grupo1/Pedidos/pedido_525.xml")
      @files = sftp.dir.entries("/home/grupo1/Pedidos")
      @datas = []
      @error = "Sin error"
      sftp.dir.entries("/home/grupo1/Pedidos").each do |remote_file|
        file = sftp.file.open("/home/grupo1/Pedidos/"+remote_file.name)
        begin
          xml_str = file.read
          doc = Nokogiri::XML(xml_str)
          @thing = doc.xpath("//Pedido")
          @chld = @thing.map do |node|
            node.children.map{ |n| [n.name, n.text.strip] if n.elem? }.compact
          end.compact
          
          @error = "Con error"
        rescue
        end


        
        #begin 
        #  @datas << file.read
        #rescue
        #end
        
      end
     end
  	end
end
