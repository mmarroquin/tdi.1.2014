class Pasar
  include ActiveModel::Model
  
  def Pasar.Spree
		puts "A"
		
		string = '{"desc":{"someKey":"someValue","anotherKey":"value"},"main_item":{"stats":{"a":8,"b":12,"c":10}}}'
		file=open("db/productos.json")
		data=file.read
		puts "b"
		texto = JSON.parse(data)#(string)
		puts "c2"
		puts texto
		for i in 0...texto.length
  		if not producto = Spree::Variant.find_by_sku(texto[i]['sku'])
    		p = Spree::Product.create :name => texto[i]['modelo'], :price => texto[i]['precio']['internet'], :description => texto[i]['descripcion'], :sku => texto[i]['sku'], :shipping_category_id => 1, :available_on => Time.now
    		img = Spree::Image.create(:attachment => open(texto[i]['imagen']), :viewable => p.master)
    		puts "i1"
    		end
  		end
		puts "B"
		end

	def Pasar.SetearStockID(id, stock)
		puts "a"
		#Spree::Product.where(:name=>'Saco De Dormir Nepal').total_on_hand
		#p=Spree::Product.where(:name=>'Saco De Dormir Nepal')
		#p = Spree::Product.find_by_name 'Saco De Dormir Nepal'
		p = Spree::Product.find('1')
		puts p
		#p.on_hand=98
		#p.master.adjust_count_on_hand = 14
		#p.total_on_hand = 14
		Spree::StockItem.where(:variant_id => Spree::Product.find(id).master.id).first.update_columns(count_on_hand: stock)
		puts "b"
	end

	def Pasar.SetearStockNombre(nombreP, stock)
		puts "a"
		#Spree::Product.where(:name=>'Saco De Dormir Nepal').total_on_hand
		#p=Spree::Product.where(:name=>'Saco De Dormir Nepal')
		#p = Spree::Product.find_by_name 'Saco De Dormir Nepal'
		#p = Spree::Product.find_by_name('1')
		puts p
		#p.on_hand=98
		#p.master.adjust_count_on_hand = 14
		#p.total_on_hand = 14
		Spree::StockItem.where(:variant_id => Spree::Product.find_by_name(nombreP).master.id).first.update_columns(count_on_hand: stock)
		puts "b"
	end

end