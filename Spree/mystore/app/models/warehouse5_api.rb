class Warehouse5_api

 include HTTParty
 default_params output: 'json'
 format :json

  $user = "grupo1"
  password = "grupo1"
  $encryptedPassword = Digest::SHA1.hexdigest(password)

  def get_prod(sku, cantidad, almacen_id)
	response = request(sku, cantidad, almacen_id)
	if !response.include?("error")
		return response["cantidad"].to_i
	else 
		return -1
	end

  end

  def request(sku, cantidad, almacen_id)
  	url =  "http://integra5.ing.puc.cl/api/v1/pedirProducto"
	return HTTParty.post(url,:body => { :usuario => $user, :password => $encryptedPassword, :almacenId => almacen_id, :sku => sku, :cantidad => cantidad })
  end

end