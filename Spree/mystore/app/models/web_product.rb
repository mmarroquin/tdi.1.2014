require 'json'
class WebProduct < ActiveRecord::Base

	belongs_to :order
	def self.read
		file = open ("/home/administrator/Dropbox/Grupo1/productos.json")
		json = file.read
		product = ActiveSupport::JSON.decode(json)
		product.each do |aux|
			cat = ''
			aux['categorias'].each do |c|
				cat += c + ','
			end
  			begin
        		prod = WebProduct.where(:sku=>aux['sku'], :description=>aux['descripcion'], :price_normal=>aux['precio']['normal'], :price_internet=>aux['precio']['internet'], :category=>cat, :img=>aux['imagen'],:model=>aux['modelo'], :brand=>aux['marca']).last
        		if prod == nil
          			WebProduct.create(:sku=>aux['sku'], :description=>aux['descripcion'], :price_normal=>aux['precio']['normal'], :price_internet=>aux['precio']['internet'], :category=>cat, :img=>aux['imagen'],:model=>aux['modelo'], :brand=>aux['marca'])
        		end
      		rescue Exception => e
        		@errors << columns
      		end  			
		end
	end

end
