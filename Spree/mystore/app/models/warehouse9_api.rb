class Warehouse9_api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo1"
  $password = "KB74LrBL"

  def get_prod(sku, cantidad, almacen_id)
	begin
	response1 = requestStock(sku)
	if response1["status"] == 200
		if response1["response"]["cantidad"] < cantidad
			response2 = requestMov(sku, response1["response"]["cantidad"], almacen_id)
		else
			response2 = requestMov(sku, cantidad, almacen_id)
		end

		if response2["status"] == 200
			return response2["response"]["cantidad"]
		else 
			return -1
		end
	else
		return -1
	end
	rescue
		return -1
	end
  end

  def requestStock(sku)
  	url = "http://integra9.ing.puc.cl/api/disponibles/#{$user}/#{$password}/" + sku
	return HTTParty.get(url)
  end

  def requestMov(sku, cantidad, almacen_id)
  	url =  "http://integra9.ing.puc.cl/api/pedirProducto/#{$user}/#{$password}/" + sku
	return HTTParty.post(url,:body => { :almacenId => almacen_id, :cantidad => cantidad })
  end	

end