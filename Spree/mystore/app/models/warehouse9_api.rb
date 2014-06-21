class Warehouse9_api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo1"
  $password = "KB74LrBL"

  def get_prod(sku, cantidad, almacen_id)
  	url = "http://integra9.ing.puc.cl/api/disponibles/#{$user}/#{$password}/" + sku
	response1 = HTTParty.get(url)
	url =  "http://integra9.ing.puc.cl/api/pedirProducto/#{$user}/#{$password}/" + sku
	if response1["status"] == 200
		if response1["response"]["cantidad"] < cantidad
			response2 = HTTParty.post(url,:body => { :almacenId => almacen_id, :cantidad => response1["response"]["cantidad"] })
		else
			response2 = HTTParty.post(url,:body => { :almacenId => almacen_id, :cantidad => cantidad })
		end

		if response2["status"] == 200
			return response2["response"]["cantidad"].to_i
		else 
			return -1
		end
	else
		return -1
	end
  end

end