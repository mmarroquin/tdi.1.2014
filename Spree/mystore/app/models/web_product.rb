require 'json'
class WebProduct < ActiveRecord::Base

	belongs_to :order
	def self.read
		file = open ("/home/valentina/productos(1).json")
		json = file.read
		product = ActiveSupport::JSON.decode(json)
		a = 0
		product.each do |aux|
  			#Product.create(:sku=>aux['sku'], :description=>aux['sku'], :start_date=>columns[3], :final_date=>columns[4])
  			a = aux['sku']
		end
		return a
	end

end
